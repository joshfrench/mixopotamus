# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def separator(char='=', length=:short)
    length = case length
      when :short then 60
      when :long then 200
    end
    "<div class=\"sep\">#{ibm(char*length)}</div>"
  end
    
    def show_flash
      html = ''
      flash.each do |key,msg|
        next if msg.nil?
        case key
          when :error then bullet = '***'
          when :confirm then bullet = '+++'
        end
        html = "<div class=\"#{key.to_s}\">"
        html << "<span class=\"bullet\">#{bullet}</span> " if bullet
        html << "#{ibm(msg)}</div>"
      end
      html
    end
    
    def errors_on(obj)
      object = instance_variable_get "@#{obj}"
      count   = [object].inject(0) {|sum, object| sum + object.errors.count }
      unless count.zero?
        errors = {}
        object.errors.each do |att,msg|
          next if msg.nil?
          # only grabs first error, hopefully you've ordered them
          # to be meaningful in your model
          errors[att] ||= msg
        end
        error_messages = errors.map { |e,msg| content_tag(:li, "<span class=\"bullet\">***</span> #{msg}") }.reverse.join "\n"
        content_tag :ul, error_messages, :class => :error
      end
    end

    def remote_submit_link(value, object, url)
      instance = instance_variable_get("@#{object}")
      instance = object.to_s.capitalize.constantize.new if instance.nil?
      method = instance.new_record? ? :post : :put
      link_to_remote "<span>#{value}</span>",
                   { :url => url,
                     :with => "Form.serialize($('#{dom_id(instance)}'))",
                     :method => method },
                   :class => :button
    end
    
    def ibm(str)
      return str if 'test' == RAILS_ENV # makes it hard to test for given strings
      ret = String.new
      str.each_byte do |b|
        m = rand(100)
          ret << case m
          when 0..2: "<span class=up>#{b.chr}</span>"
          when 3..4: "<span class=down>#{b.chr}</span>"
          when 5: "<span class=heavy>#{b.chr}</span>"
          else b.chr
        end
      end
      ret
    end
    
    def smalltime(time)
      time.strftime "%B %d"
    end
    
    def microtime(time)
      time.strftime "%B %Y"
    end
    
    def admin_email
      mail_to ADMIN_EMAIL, ibm(ADMIN_EMAIL), :encoding => "hex"
    end
    
    def fancyname_for(user)
      if Swap.count > 1
        "<span class=\"username_hover\" " +
        "title=\"#{user.login.split.first}: " +
        "#{pluralize user.swapsets.count, 'swap'}, " +
        "#{pluralize user.stars.count, 'star'} " +
        "\">" + 
        ibm(h(user.login)) + 
        "</span>"
      else
        "<span class=\"username\">#{ibm(h(user.login))}</span>"
      end
    end
    
    # multiple RJS templates need access to these #
    
    def star_for(user)
      favorite = current_user.favorited(user,@set)
      render :partial => (favorite.nil? ? "favorites/star" : "favorites/starred"), :object => user, :locals => { :favorite => favorite }
    end
    
    def confirm_for(to_user)
      assign = Assignment.find_by_swapset_id_and_user_id(@set.id, to_user.id)
      confirmation = current_user.confirms_given.by_assignment(assign)
      render :partial => (confirmation.nil? ? "confirmations/confirm" : "confirmations/confirmed"), :object => to_user, :locals => { :confirmation => confirmation, :assignment => assign }
    end
    
    def reload_user(user)
      page.replace dom_id(user), :partial => "account/userpoll", :object => user
    end
    
end

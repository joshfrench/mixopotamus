# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def separator(char='=', length=:long)
    length = case length
      when :short then 30
      when :long then 70
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
          else next # only show recognized keys
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
    
    def ibm(str)
      return str if 'test' == RAILS_ENV # makes it hard to test for given strings
      ret = String.new
      str.each_byte do |b|
        m = rand(100)
          ret << case m
          when 0..2: "<span class=\"up\">#{b.chr}</span>"
          when 3..4: "<span class=\"down\">#{b.chr}</span>"
          when 5: "<span class=\"heavy\">#{b.chr}</span>"
          else b.chr
        end
      end
      ret
    end
    
    def admin_email(text=ADMIN_EMAIL)
      mail_to ADMIN_EMAIL, ibm(text), :encode => "javascript"
    end
    
    def fancyname_for(user)
      if Swap.count > 1
        "<span class=\"username_hover\" " +
        "title=\"#{user.first_name}: " +
        "#{pluralize user.swapsets.count, 'swap'}, " +
        "#{pluralize user.stars.count, 'star'} " +
        "\">" + 
        ibm(h(user.login)) + 
        "</span>"
      else
        "<span class=\"username\">#{ibm(h(user.login))}</span>"
      end
    end
    
    def get_link_for_sidebar
      @link = case request.path
        when account_path, faq_path then ['Back to Main', default_url]
        else ['My Info', account_url]
      end
    end
    
    def do_global
      render :partial => "site/global"
    end
    
    # multiple controllers need access to these #
    
    def star_for(assignment)
      favorite = current_user.favorites.find_by_assignment_id(assignment.id)
      render :partial => (favorite.nil? ? "favorites/star" : "favorites/starred"), :object => assignment, :locals => { :favorite => favorite }
    end

    def confirm_for(assignment)
      confirmation = current_user.confirmations.find_by_assignment_id(assignment.id)
      render :partial => (confirmation.nil? ? "confirmations/confirm" : "confirmations/confirmed"), :object => assignment, :locals => { :confirmation => confirmation }
    end

    def reload_assignment(assignment)
      page.replace dom_id(assignment), :partial => "account/assignment_poll", :object => assignment
    end
    
    def hide_element(object)
      page.visual_effect :fade, dom_id(object), :duration => 0.75, :queue => 'end'
    end
    
    def show_element(object)
      page.visual_effect :appear, dom_id(object), :duration => 0.75, :queue => 'end'
    end
    
end

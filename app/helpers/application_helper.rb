# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def separator(char='=', length=:long)
    line = lambda { |x| char*x }
    sep = case length
      when :short then line.call 30
      when :long then line.call 60
    end
    "<div class=\"sep\">#{ibm(sep)}</div>"
  end
    
    def show_flash(key)
      case key
        when :error then bullet = '***'
        when :confirm then bullet = '+++'
      end
      "<div class=\"#{key.to_s}\">" + ibm("<span class=\"bullet\">#{bullet}</span> #{flash[key]}") + "</div>" unless flash[key].nil?
    end
    
    def error_message_on(object, method, prepend_text = "", append_text = "", css_class = "error")
      if (obj = instance_variable_get("@#{object}")) && (errors = obj.errors.on(method))
        content_tag("div", ibm("<span class=\"bullet\">***</span> #{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}"), :class => css_class)
      else 
        ''
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
    
end

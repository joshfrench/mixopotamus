# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def separator(char='=', length=:long)
    line = lambda { |x| char*x }
    sep = case length
      when :short then line.call 30
      when :long then line.call 60
    end
    "<div class=\"sep\">#{sep}</div>"
  end
  
  def submit_button_tag(value = "Save changes", options = {})
    options.stringify_keys!
 
    if disable_with = options.delete("disable_with")
     options["onclick"] = "this.disabled=true;this.value='#{disable_with}';this.form.submit();#{options["onclick"]}"
    end
   
    tag :button, { "type" => "submit", "name" => "commit", "value" => value }.update(options.stringify_keys)
    end
    
    def show_flash(key)
      case key
        when :error then bullet = '***'
        when :confirm then bullet = '+++'
      end
      "<div class=\"#{key.to_s}\"><span class=\"bullet\">#{bullet}</span> #{flash[key]}</div>" unless flash[key].nil?
    end
    
    def error_message_on(object, method, prepend_text = "", append_text = "", css_class = "error")
      if (obj = instance_variable_get("@#{object}")) && (errors = obj.errors.on(method))
        content_tag("div", "<span class=\"bullet\">***</span> #{prepend_text}#{errors.is_a?(Array) ? errors.first : errors}#{append_text}", :class => css_class)
      else 
        ''
      end
    end
end

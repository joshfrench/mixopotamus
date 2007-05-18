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
end

module SafariUnicodeFix
  def self.included(controller)
    controller.after_filter(:fix_unicode_for_safari)
  end

  private
  def fix_unicode_for_safari
    if headers["Content-Type"] == "text/html; charset=utf-8" && request.env['HTTP_USER_AGENT'] && request.env['HTTP_USER_AGENT'].include?('AppleWebKit') && !response.body.blank? then
      response.body.to_s.gsub!(/([^\x00-\xa0])/u) { |s|
"&#x%x;" % $1.unpack('U')[0] rescue $1 }
    end
  end
end
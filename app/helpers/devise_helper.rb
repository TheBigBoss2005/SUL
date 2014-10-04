module DeviseHelper
  def devise_error_messages!
    resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end

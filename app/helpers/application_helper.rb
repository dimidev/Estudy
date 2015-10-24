module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Set title for page
  def title(page_title)
    content_for :page_title, page_title.to_s.html_safe
  end
end

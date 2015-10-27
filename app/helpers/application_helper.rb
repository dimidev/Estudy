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

  # User or Institution avatar btn on header navbar
  def header_nav_avatar
    if current_user.role? :superadmin
      avatar = current_user.institution.institution_logo.url(:thumb)
    else
      avatar = current_user.user_avatar.url(:thumb)
    end

    image_tag(avatar, class: 'img-squared', id: 'nav-user-avatar')
  end

  # Path by user
  def edit_path_by_user(user=current_user)
    if user.role? :superadmin
      send("edit_#{user.model_name.singular}_path")
    else
      send("edit_#{user.model_name.singular}_path", user)
    end
  end

  # Helpers for nested forms
  def add_nested_resource(resource, target, div_target=nil, content=nil, translate=true)
    content ||= target.to_s.singularize
    content = t("mongoid.models.#{content}.one") if translate
    div_target ||= ".#{target.to_s}"

    resource.link_to_add(fa_icon('plus', text: t('simple_form.nested_btn.add', model: content)), target, data:{target: div_target}, class:'btn btn-primary')
  end

  def remove_nested_resource(resource, options={})
    if options[:content] == false
      resource.link_to_remove(fa_icon('trash-o'), class:'btn btn-danger', data:{toggle:'tooltip', title: t('simple_form.nested_btn.defaults.remove')})
    else
      content = options[:content] || resource.object.model_name.singular
      content = t("mongoid.models.#{content}.one") if options[:translate].blank?
      resource.link_to_remove(fa_icon('trash-o',text: t('simple_form.nested_btn.remove', model: content)), class:'btn btn-danger')
    end
  end

  # Cancel link for forms
  def cancel_btn(path, options={})
    btn_class = 'btn btn-warning'
    btn_class << ' ' << options[:class] if options[:class].present?

    link_to t('btn.cancel'), path, class: btn_class
  end
end

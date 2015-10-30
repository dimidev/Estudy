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
  def add_nested_resource(resource, nested_resource, options={})
    target = options[:target].present? ? options[:target] : ".#{nested_resource.to_s}"

    if options[:content] == false
      resource.link_to_add(fa_icon('plus'), nested_resource, data:{target: target, toggle:'tolltip', title: t('simple_form.nested_btn.defaults.add')}, class:'btn btn-primary')
    else
      content = options[:content] || nested_resource.to_s.singularize
      content = t("mongoid.models.#{content}.one") if options[:localize] && options[:content].blank?
      resource.link_to_add(fa_icon('plus', text: t('simple_form.nested_btn.add', model: content)), nested_resource, data:{target: target}, class:'btn btn-primary')
    end
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

  def delete_btn(resource)
    if %w(edit update).include?(controller.action_name)
      link_to(t('btn.delete'), send("#{resource.model_name.singular}_path", resource.id) , method: :delete, class:'btn btn-danger pull-right', data:{confirm: t('confirmation.delete')})
    end
  end
end
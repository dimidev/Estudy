class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :error

  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  add_breadcrumb "<i class='fa fa-home'></i>".html_safe, :root_path

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end

  private

  # Define layout by resource
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  # Options for user association
  def user_departments(user=current_user)
    if user.role? :superadmin
      @departments = Department.active
    else
      @departments = @department || user.department
    end
  end

  # Set application language
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Default url locale options
  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  # TODO change message with i18n
  # Catching exceptions from CanCanCan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end
end

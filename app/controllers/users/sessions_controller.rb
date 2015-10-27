class Users::SessionsController < Devise::SessionsController
  # before_filter :configure_sign_in_params, only: [:create]

  # If Institution not exists, then call :create_institution method
  before_action :create_institution, unless: lambda{ Institution.exists? }

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in_without_redirect(resource_name, resource)
    @after_sign_in_path = after_sign_in_path(resource)
  end

  def sign_in_without_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
  end

  def failure
    respond_to do |format|
      flash.now[:alert] = I18n.t('devise.failure.invalid')
      format.js {render 'login_failure.destroy.js.erb'}
    end
  end

  def after_sign_in_path(resource_or_scope)
    root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end


  def create_institution
    redirect_to new_institution_path
  end
end
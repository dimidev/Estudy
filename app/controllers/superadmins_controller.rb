class SuperadminsController < ApplicationController
  load_and_authorize_resource

  def edit
    add_breadcrumb I18n.t('superadmins.edit.title'), :root_path
    @superadmin = Superadmin.first
  end

  def update
    add_breadcrumb I18n.t('superadmins.edit.title'), :root_path
    @superadmin = Superadmin.first

    if update_resource(@superadmin, superadmin_params)
      redirect_to root_path, notice: I18n.t('mongoid.success.models.superadmin.update')
    else
      flash[:alert] = I18n.t('mongoid.errors.models.superadmin.update')
      render :edit
    end
  end

  private
  def superadmin_params
   params.require(:superadmin).permit(:email, :password, :password_confirmation)
  end

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_attributes(params)
    else
      resource.update_without_password(params)
    end
  end
end

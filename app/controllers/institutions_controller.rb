class InstitutionsController < ApplicationController
  load_and_authorize_resource except: [:new, :create]

  skip_before_action :authenticate_user!, only: [:new, :create], unless: lambda { Institution.exists? }
  before_action :redirect_if_exists, only: [:new, :create]

  layout 'devise', only: [:new, :create]

  add_breadcrumb I18n.t('mongoid.models.institution.one'), :institution_path

  def new
    @institution = Institution.new
    @superadmin = @institution.build_superadmin
  end

  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      sign_in(:user, @institution.superadmin)
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t('institutions.edit.title')
    @institution = Institution.first
  end

  def update
    add_breadcrumb I18n.t('institutions.edit.title')
    @institution = Institution.first

    if @institution.update_attributes(institution_params)
      redirect_to root_path, notice: I18n.t('mongoid.success.models.course.update')
    else
      flash[:alert] = I18n.t('mongoid.errors.models.course.update')
      render :edit
    end
  end

  private
  def institution_params
    params.require(:institution).permit(:institution_logo, :institution_baner, :title, :short_title, :foundation_date,
                                        address_attributes: [:country, :city, :postal_code, :address],
                                        contacts_attributes:[:id, :_destroy, :type, :value],
                                        superadmin_attributes: [:email, :password, :password_confirmation])
  end

  def redirect_if_exists
    redirect_to root_path if Institution.exists?
  end
end

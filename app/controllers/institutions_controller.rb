class InstitutionsController < ApplicationController
  load_and_authorize_resource except: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new, :create], unless: lambda { Institution.exists? }

  layout 'devise', only: [:new, :create]

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

  private
  def institution_params
    params.require(:institution).permit(:institution_logo, :title, :short_title, :foundation_date,
                                        address_attributes: [:country, :city, :postal_code, :address],
                                        superadmin_attributes: [:email, :password, :password_confirmation])
  end
end

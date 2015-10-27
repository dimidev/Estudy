class ProfessorsController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(params[:department_id])
    add_breadcrumb I18n.t('professors.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Professor.where(department_ids: params[:department_id]).datatable(self, %w(name lastname semester)) do |professor|
                 [
                     professor.name,
                     professor.lastname,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_professor_path(professor) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), professor_path(professor), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(params[:department_id])
    add_breadcrumb I18n.t('professors.new.title')
    @department = Department.find(params[:department_id])
    @professor = Professor.new

    @departments = Department.active

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(params[:department_id])
    add_breadcrumb I18n.t('professors.new.title')
    @department = Department.find(params[:department_id])
    @professor = Professor.new(professor_params)

    if @professor.save
      flash[:notice] = t('mongoid.success.models.user.create', model: Professor.model_name.human, name: @professor.fullname)
      redirect_to department_professors_path(params[:department_id])
    else
      @departments = Department.active

      flash[:alert] = t('mongoid.errors.models.user.create', model: Professor.model_name.human, name: @professor.fullname)
      render :edit
    end
  end

  def edit
    @professor = Professor.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(current_user.department)
    add_breadcrumb I18n.t('professors.edit.title')

    @departments = Department.active
  end

  def update
    @professor = Professor.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(current_user.department)
    add_breadcrumb I18n.t('professors.edit.title')

    if update_resource(@professor, professor_params)
      flash[:notice] = I18n.t('mongoid.success.models.user.update', model: Professor.model_name.human, name: @professor.fullname)
      redirect_to department_professors_path(current_user.department)
    else
      @departments = Department.active

      flash[:alert] = I18n.t('mongoid.errors.models.user.update', model: Professor.model_name.human)
      render :edit
    end
  end

  def destroy
    @professor = Professor.find(params[:id])

    respond_to do |format|
      if @professor.destroy
        message = I18n.t('mongoid.success.models.user.destroy', model: Professor.model_name.human, name: @professor.fullname)
        format.html { redirect_to department_professors_path(current_user.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.models.user.destroy', model: Professor.model_name.human, name: @professor.fullname)
        format.html { render :edit, flash[:alert]= message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private

  def professor_params
    params.require(:professor).permit(:user_avatar, :email, :password, :password_confirmation, :role,
                                      :name, :lastname, :gender, :birthdate, :nic, :trn, department_ids: [],
                                      addresses_attributes: [:id, :_destroy, :country, :city, :postal_code, :address, :primary],
                                      contacts_attributes: [:id, :_destroy, :type, :value])

  end

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_attributes(params)
    else
      resource.update_without_password(params)
    end
  end
end

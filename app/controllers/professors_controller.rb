class ProfessorsController < ApplicationController
  load_and_authorize_resource

  def index
    @department = Department.find(params[:department_id])
    add_breadcrumb @department.title, department_professors_path(@department), if: lambda{current_user.role? :superadmin}
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(@department)
    add_breadcrumb I18n.t('professors.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Professor.where(department_ids: params[:department_id]).datatable(self, %w(name lastname professor_type)) do |professor|
                 [
                     professor.name,
                     professor.lastname,
                     professor.email,
                     professor.professor_type_text,
                     professor.professor_office.name,
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

    @offices = Hall.office

    if current_user.role? :superadmin
      @departments = Department.all
    else
      # TODO add code for admin
    end

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
      @offices = Hall.office

      flash[:alert] = t('mongoid.errors.models.user.create', model: Professor.model_name.human, name: @professor.fullname)
      render :edit
    end
  end

  def edit
    @professor = Professor.find(params[:id])

    # FIXME breadcrumb not working properly on superadmin mode
    # add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(current_user.department), if: lambda{current_user.role? :admin}
    add_breadcrumb I18n.t('professors.edit.title')

    @offices = Hall.office

    if current_user.role? :superadmin
      @departments = Department.all
    else
      # TODO add code for admin
    end
  end

  def update
    @professor = Professor.find(params[:id])

    # FIXME breadcrumb not working properly on superadmin mode
    #add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(current_user.department)
    add_breadcrumb I18n.t('professors.edit.title')

    if update_resource(@professor, professor_params)
      flash[:notice] = I18n.t('mongoid.success.models.user.update', model: Professor.model_name.human, name: @professor.fullname)

      if current_user.role? :admin
        redirect_to department_professors_path(current_user.department)
      else
        redirect_to root_path
      end
    else
      @departments = Department.active
      @offices = Hall.office

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
    params.require(:professor).permit(:user_avatar, :email, :password, :password_confirmation, :role, :professor_type, :professor_office_id,
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

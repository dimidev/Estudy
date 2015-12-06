class ProfessorsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource :professor, through: :department, shallow: true

  def index
    @department = Department.find(params[:department_id])
    add_breadcrumb @department.title, department_professors_path(@department) if current_user.role?(:superadmin)
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(@department)
    add_breadcrumb I18n.t('professors.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: @department.professors.datatable(self, %w(name lastname email professor_type)) do |professor|
                 [
                     %{<%= link_to professor.name, professor_path(professor) %>},
                     %{<%= link_to professor.lastname, professor_path(professor) %>},
                     professor.email,
                     professor.professor_type_text,
                     (professor.professor_office.name if professor.has_professor_office?),
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
    @professor = @department.professors.build

    @offices = Hall.available_offices

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(params[:department_id])
    add_breadcrumb I18n.t('professors.new.title')
    @department = Department.find(params[:department_id])
    @professor =  @department.professors.build(professor_params)

    if @professor.save
      flash[:notice] = t('mongoid.success.users.create', model: Professor.model_name.human, name: @professor.fullname)
      redirect_to department_professors_path(params[:department_id])
    else
      @departments = Department.active
      @offices = Hall.available_offices
      render :edit
    end
  end

  def show
    @professor = Professor.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(@professor.department)
    add_breadcrumb I18n.t('professors.show.title')

    @office_time = @professor.office_times.order_by(day: :asc)
    @addresses = @professor.addresses
    @phones = @professor.contacts.phones.map(&:value).join(', ')
    @fax = @professor.contacts.fax.map(&:value).join(', ')
    @emails = [@professor.email, @professor.contacts.emails.map(&:value)].flatten.join(', ')
  end

  def edit
    @professor = Professor.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(@professor.department)
    add_breadcrumb I18n.t('professors.edit.title')

    @offices = [@professor.professor_office, Hall.available_offices].flatten.compact.uniq
  end

  def update
    @professor = Professor.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.professor.other'), department_professors_path(@professor.department)
    add_breadcrumb I18n.t('professors.edit.title')

    if update_resource(@professor, professor_params)
      flash[:notice] = I18n.t('mongoid.success.users.update', model: Professor.model_name.human, name: @professor.fullname)
      redirect_to department_professors_path(current_user.department)
    else
      @offices = [@professor.professor_office, Hall.available_offices].flatten.compact.uniq
      render :edit
    end
  end

  def destroy
    @professor = Professor.find(params[:id])

    respond_to do |format|
      if @professor.destroy
        message = I18n.t('mongoid.success.users.destroy', model: Professor.model_name.human, name: @professor.fullname)
        format.html { redirect_to department_professors_path(@professor.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.users.destroy', model: Professor.model_name.human, name: @professor.fullname)
        format.html { render :edit, flash[:alert]= message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private

  def professor_params
    params.require(:professor).permit(:user_avatar, :email, :password, :password_confirmation, :role, :professor_type, :professor_office_id,
                                      :name, :lastname, :gender, :birthdate, :nic, :trn, :ssn, :tax_office,
                                      addresses_attributes: [:id, :_destroy, :country, :city, :postal_code, :address, :primary],
                                      contacts_attributes: [:id, :_destroy, :type, :value],
                                      office_times_attributes: [:id, :_destroy, :day, :from, :to])

  end

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_attributes(params)
    else
      resource.update_without_password(params)
    end
  end
end

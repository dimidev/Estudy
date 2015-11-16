class StudentsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource :student, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(params[:department_id])
    add_breadcrumb I18n.t('students.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.find(params[:department_id]).students.order_by(stc: :desc).datatable(self, %w(stc name lastname birthdate semester status)) do |student|
                 [
                     student.stc,
                     %{<%= link_to student.name, student_path(student) %>},
                     %{<%= link_to student.lastname, student_path(student) %>},
                     student.birthdate.strftime('%d-%m-%Y'),
                     student.semester,
                     student.status_text,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <% if can? :index, Grade %>
                            <li><%= link_to fa_icon('tasks', text: I18n.t('mongoid.models.grade.special')), student_grades_path(student) %></li>
                          <% end %>
                          <% if can? :index, Registration %>
                            <li><%= link_to fa_icon('tasks', text: I18n.t('mongoid.models.registration.other')), student_registrations_path(student) %></li>
                          <% end %>
                          <% if can? [:update, :destroy], Student %>
                            <li class='divider'></li>
                            <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_student_path(student) %></li>
                            <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), student_path(student), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                          <% end %>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(params[:department_id])
    add_breadcrumb I18n.t('students.new.title')

    @department = Department.find(params[:department_id])

    if @department.studies_programmes.exists?
      @student = @department.students.build
      render :edit
    else
      redirect_to department_studies_programmes_path(@department), alert: I18n.t('mongoid.errors.studies_programmes.no_exists')
    end
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(params[:department_id])
    add_breadcrumb I18n.t('students.new.title')
    @department = Department.find(params[:department_id])
    @student = @department.students.build(student_params)

    if @student.save
      flash[:notice] = t('mongoid.success.users.create', model: Student.model_name.human, name: @student.fullname)
      redirect_to department_students_path(params[:department_id])
    else
      render :edit
    end
  end

  def show
    @student = Student.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(@student.department)
    add_breadcrumb I18n.t('students.show.title')

    @addresses = @student.addresses
    @phones = @student.contacts.phones.map(&:value).join(', ')
    @fax = @student.contacts.fax.map(&:value).join(', ')
    @emails = [@student.email, @student.contacts.emails.map(&:value)].flatten.join(', ')
  end

  def edit
    @student = Student.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(@student.department)
    add_breadcrumb I18n.t('students.edit.title')
  end

  def update
    @student = Student.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.student.other'), department_students_path(@student.department)
    add_breadcrumb I18n.t('students.edit.title')

    if update_resource(@student, student_params)
      flash[:notice] = I18n.t('mongoid.success.users.update', model: Student.model_name.human, name: @student.fullname)
      redirect_to department_students_path(@student.department)
    else
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.destroy
        message = I18n.t('mongoid.success.users.destroy', model: Student.model_name.human, name: @student.fullname)

        format.html { redirect_to department_students_path(@student.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.users.destroy', model: Student.model_name.human, name: @student.fullname)
        format.html { render :edit, alert: message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private

  def student_params
    params.require(:student).permit(:studies_programme_id, :user_avatar, :email, :password, :password_confirmation, :role, :status,
                                    :name, :lastname, :gender, :birthdate, :nic, :trn, :semester,
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

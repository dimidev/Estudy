class DepartmentsController < ApplicationController
  load_and_authorize_resource
  include DepartmentsHelper

  def index
    add_breadcrumb I18n.t('mongoid.models.department.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.datatable(self, %w(title foundation_date status)) do |department|
                 [
                     %{<%= link_to department.title, department_path(department) %>},
                     department.foundation_date,
                     department_status(department.status),
                     department.students.active.count,
                     department.professors.count,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <% if can? :index, Admin %>
                            <li><%= link_to fa_icon('users', text: I18n.t('mongoid.models.admin.admins')), department_admins_path(department) %></li>
                          <% end %>
                          <% if can? :index, Professor %>
                            <li><%= link_to fa_icon('users', text: I18n.t('mongoid.models.professor.other')), department_professors_path(department) %></li>
                          <% end %>
                          <% if can? :index, Student %>
                            <li><%= link_to fa_icon('users', text: I18n.t('mongoid.models.student.other')), department_students_path(department) %></li>
                          <li class='divider'></li>
                          <% end %>
                          <% if can? :index, StudiesProgramme %>
                            <li><%= link_to fa_icon('book', text: I18n.t('mongoid.models.studies_programme.other')), department_studies_programmes_path(department) %></li>
                          <% end %>
                          <% if can? :index, Exam %>
                            <li><%= link_to fa_icon('calendar', text: I18n.t('mongoid.models.exam.other')), department_exams_path(department) %></li>
                          <% end %>
                          <% if can? :index, Timetable %>
                            <li><%= link_to fa_icon('calendar', text: Timetable.model_name.human), department_timetables_path(department) %></li>
                          <% end %>
                          <% if can? [:update, :destroy], Department %>
                            <li class='divider'></li>
                            <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_department_path(department) %></li>
                            <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), department_path(department), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                          <% end %>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.department.other'), departments_path
    add_breadcrumb I18n.t('departments.new.title')

    @department = Department.new
    @department.build_address

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.department.other'), departments_path
    add_breadcrumb I18n.t('departments.new.title')

    @department = Institution.first.departments.build(department_params)

    if @department.save
      redirect_to departments_path, notice: I18n.t('mongoid.success.departments.create', title: @department.title)
    else
      render :edit
    end
  end

  def show
    add_breadcrumb I18n.t('mongoid.models.department.other'), departments_path if current_user.role?(:superadmin)
    add_breadcrumb I18n.t('departments.show.title')

    @department = Department.find(params[:id])

    @phones = @department.contacts.where(type: 'phone').map(&:value).join(', ')
    @fax = @department.contacts.where(type: 'fax').map(&:value).join(', ')
    @emails = @department.contacts.where(type: 'email').map(&:value).join(', ')
  end

  def edit
    add_breadcrumb I18n.t('mongoid.models.department.other'), departments_path if current_user.role?(:superadmin)
    add_breadcrumb I18n.t('departments.edit.title')

    @department = Department.find(params[:id])

    render :edit
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.department.other'), departments_path if current_user.role?(:superadmin)
    add_breadcrumb I18n.t('departments.edit.title')

    @department = Department.find(params[:id])

    if @department.update_attributes(department_params)
      flash[:notice] = I18n.t('mongoid.success.departments.update', title: @department.title)
      redirect_to current_user.role?(:superadmin) ? departments_path : department_path(@department)
    else
      render :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.destroy
        message = I18n.t('mongoid.success.departments.destroy', title: @department.title)
        format.html { redirect_to departments_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.departments.destroy', title: @department.title)
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:department_logo, :delete_img, :title, :foundation_date, :status, :head_of_department,
                                       address_attributes: [:country, :city, :postal_code, :address],
                                       contacts_attributes: [:id, :_destroy, :type, :value])
  end
end

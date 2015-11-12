class RegistrationsController < ApplicationController
  load_and_authorize_resource :student
  load_and_authorize_resource :registration, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.index.title')

    # FIXME count per percent too not only ects
    respond_to do |format|
      format.html{ flash[:notice] = I18n.t('mongoid.success.models.registration.registrations_period') if Timetable.current }
      format.json do
        render(json: Student.find(params[:student_id]).registrations.datatable(self, %w(id)) do |registration|
                 [
                     %{<%= link_to registration.timetable.period, registration_path(registration) %>},
                     registration.registrations.count,
                     registration.registrations.map{|child| child.course.has_parent_course? ? child.course.parent_course.ects : child.course.ects}.sum,
                     registration.registrations.map{|child| child.course.hours}.sum,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_registration_path(registration) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), registration_path(registration), method: :delete, remote: true, data:{confirm: 'Are you sure ?'} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.new.title')

    if Timetable.current
      @student = Student.find(params[:student_id])
      @registration = @student.registrations.build
      @registration.registrations.build

      if @student.studies_programme.courses.exists?
        @courses = @student.available_courses
        render :edit
      else
        redirect_to department_students_path(@student.department), alert: t('mongoid.errors.models.registration.no_courses')
      end
    else
      redirect_to student_registrations_path(params[:student_id]), alert: t('mongoid.errors.models.registration.registrations_period')
    end
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.new.title')

    @student = Student.find(params[:student_id])
    @registration = @student.registrations.build(registration_params)

    if @registration.save
      redirect_to student_registrations_path(params[:student_id]), notice: I18n.t('mongoid.success.models.registration.create')
    else
      @courses = @student.available_courses
      render :edit, alert: I18n.t('mongoid.errors.models.registration.create')
    end
  end

  def current
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.current.title')

    # FIXME
    @registration = Student.find(params[:student_id]).registrations.first
    @courses = @registration.courses
  end

  def edit
    @registration = Registration.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(@registration.student)
    add_breadcrumb I18n.t('registrations.edit.title')

    @courses = @registration.student.available_courses
  end

  def update
    @registration = Registration.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(@registration.student)
    add_breadcrumb I18n.t('registrations.edit.title')

    if @registration.update_attributes(registration_params)
      redirect_to student_registrations_path(@registration.student), notice: I18n.t('mongoid.success.models.registration.update')
    else
      @courses = @registration.student.available_courses
      flash[:alert] = I18n.t('mongoid.errors.models.registration.update')
      render :edit
    end
  end

  def destroy
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.destroy
        format.js{flash.now[:notice]= t('mongoid.success.models.registration.destroy')}
      else
        format.js{flash.now[:alert] = t('mongoid.errors.models.registration.destroy')}
      end
    end
  end

  private

  def registration_params
    params.require(:registration).permit(course_ids:[])
  end
end

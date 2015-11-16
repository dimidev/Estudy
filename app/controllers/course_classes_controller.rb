class CourseClassesController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource :course_class, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('course_classes.index.title')

    @department = Department.find(params[:department_id])

    if current_user.role? :superadmin
      @course_classes = @department.course_classes
    else
      @course_classes = @department.course_classes.where(professor_id: current_user)
    end

    respond_to do |format|
      format.html
      format.json do
        render(json: @course_classes.datatable(self, %w(id)) do |course_class|
          [
              (course_class.course.has_parent_course? ? "#{course_class.course.title} (#{course_class.course.course_part_text})" : course_class.course.title),
              course_class.hall.name,
              course_class.hall.building.name,
              course_class.professor.fullname,
              course_class.registrations.count,
              "#{course_class.from.to_s(:time)} - #{course_class.to.to_s(:time)}",
              %{<div class="btn-group">
                  <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                  <ul class="dropdown-menu dropdown-center">
                    <li><%= link_to fa_icon('users', text: I18n.t('mongoid.attributes.course_class.registared_students')), students_course_class_path(course_class), remote: true %></li>
                    <li class='divider'></li>
                    <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_course_class_path(course_class), remote: true %></li>
                    <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), course_class_path(course_class), method: :delete, remote: true, data:{confirm: 'Are you sure ?'} %></li>
                  </ul>
                </div>}
          ]
        end)
      end
    end
  end

  def new
    @department = Department.find(params[:department_id])
    @course_class = @department.course_classes.build

    @courses = @department.courses_for_class
    @professors = @department.professors
    @halls = Hall.ne(type: :office)

    respond_to do |format|
      format.js{render 'course_classes/js/edit'}
    end
  end

  def create
    @department = Department.find(params[:department_id])
    @oourse_class = @department.course_classes.build(course_class_params)

    respond_to do |format|
      if @course_class.save
        message = I18n.t('mongoid.success.models.course_class.create', course: @course_class.course.title)
        flash.now[:notice] = message
        format.js { render 'course_classes/js/save' }
      else
        @courses = @department.courses_for_class
        @professors = @department.professors
        message = I18n.t('mongoid.errors.models.course_class.create')
        flash.now[:alert] = message
        format.js { render 'course_classes/js/save' }
      end
    end
  end

  def edit
    @course_class = CourseClass.find(params[:id])

    department = @course_class.department
    @courses = department.courses_for_class
    @professors = department.professors
    @halls = Hall.ne(type: :office)

    respond_to do |format|
      format.js{render 'course_classes/js/edit'}
    end
  end

  def update
    @course_class = CourseClass.find(params[:id])

    respond_to do |format|
      if @course_class.update_attributes(course_class_params)
        message = I18n.t('mongoid.success.models.course_class.update', course: @course_class.course.title)
        flash.now[:notice] = message
        format.js { render 'course_classes/js/save' }
      else
        department = @course_class.department
        @courses = department.courses_for_class
        @professors = department.professors
        @halls = Hall.ne(type: :office)

        message = I18n.t('mongoid.errors.models.course_class.update')
        flash.now[:alert] = message
        format.js { render 'course_classes/js/save' }
      end
    end
  end

  def destroy
    @course_class = CourseClass.find(params[:id])

    respond_to do |format|
      if @course_class.destroy
        message = I18n.t('mongoid.success.models.course_class.destroy', course: @course_class.course.title)
        flash.now[:notice] = message
        format.js { render 'course_classes/js/destroy' }
      else
        message = I18n.t('mongoid.errors.models.course_class.destroy')
        flash.now[:alert] = message
        format.js { render 'course_classes/js/destroy' }
      end
    end
  end

  def students
    @course_class = CourseClass.find(params[:id])

    respond_to do |format|
      format.js{render 'course_classes/js/students'}
      format.json do
        render(json: @course_class.registrations.datatable(self, %w(fullname stc semester)) do |registration|
          [
              %{<=link_to registration.student.fullname, student_path(registration.student) %>},
              registration.student.stc,
              registration.student.semester
          ]
        end)
      end
    end
  end

  private
  def course_class_params
    params.require(:course_class).permit(:course_id, :professor_id, :hall_id, :day, :from, :to)
  end
end

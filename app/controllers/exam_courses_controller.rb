class ExamCoursesController < ApplicationController
  load_and_authorize_resource :exam
  load_and_authorize_resource :exam_course, through: :exam, shallow: true

  def index
    respond_to do |format|
      format.html
      format.json do
        if params[:type]=='labs'
          render(json: Exam.find(params[:exam_id]).exam_courses.where(:course_class_id.ne=>nil).datatable(self, %w(exam_day exam_day name name)) do |exam_course|
            [
                "#{exam_course.course_class.course.title} (#{exam_course.course_class.day_text} #{exam_course.course_class.from.to_s(:time)}-#{exam_course.course_class.to.to_s(:time)})",
                exam_course.exam_day,
                exam_course.course_class.hall.name,
                exam_course.course_class.professor.fullname,
                exam_course.course_class.registrations.count,
                %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_exam_course_path(exam_course), remote: true %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), exam_course_path(exam_course), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
            ]
          end)
        else
          render(json: Exam.find(params[:exam_id]).exam_courses.where(:course_id.ne=>nil).datatable(self, %w(exam_day exam_day)) do |exam_course|
            [
                exam_course.course.title,
                exam_course.exam_day,
                exam_course.halls.map(&:name).join(', '),
                exam_course.professors.map(&:fullname).join(', '),
                exam_course.course.registrations.count,
                %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_exam_course_path(exam_course), remote: true %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), exam_course_path(exam_course), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
            ]
          end)
        end
      end
    end
  end

  def new
    @exam = Exam.find(params[:exam_id])
    @exam_course = @exam.exam_courses.build

    @professors = Professor.all
    @halls = Hall.all

    if params[:type] == 'lab'
      @lab_courses = CourseClass.all
    elsif params[:type] == 'theory'
      @theory_courses = Course.all
    end

    respond_to do |format|
      format.js{render 'exam_courses/js/edit'}
    end
  end

  def create
    @exam = Exam.find(params[:exam_id])
    @exam_course = @exam.exam_courses.build(exam_course_params)

    respond_to do |format|
      if @exam_course.save
        flash.now[:notice] = I18n.t('mongoid.success.exam_courses.create')
      else
        @professors = Professor.all
        @halls = Hall.all

        if @exam_course.has_course_class?
          @lab_courses = CourseClass.all
        else
          @theory_courses = Course.all
        end
      end
      format.js{render 'exam_courses/js/save'}
    end
  end

  def edit
    @exam_course = ExamCourse.find(params[:id])

    @professors = Professor.all
    @halls = Hall.all

    if @exam_course.has_course_class?
      @lab_courses = CourseClass.all
    else
      @theory_courses = Course.all
    end

    respond_to do |format|
      format.js{render 'exam_courses/js/edit'}
    end
  end

  def update
    @exam_course = ExamCourse.find(params[:id])

    if @exam_course.update_attributes(exam_course_params)
      flash.now[:alert] = I18n.t('mongoid.success.exam_courses.update')
    else
      @professors = Professor.all
      @halls = Hall.all

      if @exam_course.has_course_class?
        @lab_courses = CourseClass.all
      else
        @theory_courses = Course.all
      end
    end

    respond_to do |format|
      format.js{render 'exam_courses/js/save'}
    end
  end

  def destroy
    @exam_course = ExamCourse.find(params[:id])

    respond_to do |format|
      if @exam_course.destroy
        flash.now[:notice] = I18n.t('mongoid.success.exam_courses.destroy')
      else
        flash.now[:alert] = I18n.t('mongoid.errors.exam_courses.destroy')
      end
      format.js { render 'exam_courses/js/destroy' }
    end
  end

  private
  def exam_course_params
    params.require(:exam_course).permit(:day, :from, :to, :course_id, :course_class_id, professor_ids:[], hall_ids:[])
  end
end
class ExamsController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource :exam, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('mongoid.models.exam.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.find(params[:department_id]).exams.datatable(self, %w(name)) do |exam|
          [
              exam.timetable.period,
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_exam_path(exam) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), exam_path(exam), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def new
    @department = Department.find(params[:department_id])
    @exam = @department.exams.build

    respond_to do |format|
      format.js{render 'exams/js/new'}
    end
  end

  def create
    @department = Department.find(params[:department_id])
    @exam = @department.exams.build(exam_params)

    respond_to do |format|
      if @exam.save
        flash[:notice] = I18n.t('mongoid.success.exams.create', period: @exam.timetable.period)
      else
        flash.now[:alert] = I18n.t('mongoid.errors.exams.create', period: @exam.timetable.period)
      end
      format.js{render 'exams/js/create'}
    end
  end

  def show
    @exam = Exam.find(params[:id])

    respond_to do |format|
      format.html
      format.json do
        render(json: @exam.exams.datatable(self, %w(name)) do |exam|
          [
              (exam.course.has_parent_course? ? "#{exam.course.title} (#{exam.course.course_part})" : exam.course.title),
              (exam.course.has_parent_course? ? "#{exam.course.parent_course.course_type_text}" : exam.course.course_type_text),
              exam.hall.name,
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_exam_path(exam) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), exam_path(hall), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def edit
    @exam = Exam.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.exam.other'), department_exams_path(@exam.department)
    add_breadcrumb I18n.t('exams.edit.title')

    render :edit
  end

  def update
    @hall = Hall.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.hall.other'), building_halls_path(@hall.building)
    add_breadcrumb I18n.t('halls.edit.title')

    if @hall.update_attributes(hall_params)
      redirect_to building_halls_path(@hall.building), notice: I18n.t('mongoid.success.models.hall.update', name: @hall.name)
    else
      flash[:alert] = I18n.t('mongoid.errors.models.hall.update')
      render :edit
    end
  end

  def destroy
    @exam = Exam.find(params[:id])

    respond_to do |format|
      if @exam.destroy
        message = I18n.t('mongoid.success.exams.destroy', period: @exam.timetable.period)
        format.html { redirect_to department_exams_path(@exams.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.exams.destroy', period: @exam.timetable.period)
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  def add_theory
    @exam = Exam.find(params[:id])
    department = @exam.department
    @labs = department.courses.where()

    respond_to do |format|
      format.js{render 'exams/js/add_course'}
    end
  end

  private
  def exam_params
    params.require(:exam).permit(:timetable_id, :theory_start, :theory_end, :lab_start, :lab_end)
  end
end

class AttendancesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        render(json: CourseClass.find(params[:course_class_id]).attendances.datatable(self, %w(from to)) do |attendance|
          [
              attendance.date,
              attendance.students.count,
              (attendance.course_class.registrations.count - attendance.students.count),
              %{<div class="btn-group">
                  <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                  <ul class="dropdown-menu dropdown-center">
                    <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_attendance_path(attendance), remote: true %></li>
                    <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), attendance_path(attendance), method: :delete, remote: true, data:{confirm: 'Are you sure ?'} %></li>
                  </ul>
                </div>}
          ]
        end)
      end
    end
  end

  def new
    @course_class = CourseClass.find(params[:course_class_id])
    @attendance = @course_class.attendances.build

    render :edit
  end

  def create
    @course_class = CourseClass.find(params[:course_class_id])
    @attendance = @course_class.attendances.build(attendance_params)

    unless @attendance.save

    end

    render :save
  end

  private
  def attendance_params
    params.require(:attendance).permit(:day, student_ids: [])
  end
end

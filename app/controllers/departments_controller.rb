class DepartmentsController < ApplicationController
  load_and_authorize_resource

  def index
    I18n.t('departments.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.datatable(self, %w(short_title foundation_date)) do |department|
                 [
                     department.title,
                     department.foundation_date,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('book', text: I18n.t('mongoid.models.grade.rating')), student_grades_path(student) %></li>
                          <li class='divider'></li>
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_department_path(department) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), department_path(department), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    I18n.t('departments.new.title')

    @department = Institution.first.departments.build

    render :edit
  end

  private
  def department_params
    params.require(:department).permit(:department_logo, :title, :short_title, :foundation_date)
  end
end

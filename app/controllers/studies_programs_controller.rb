class StudiesProgramsController < ApplicationController
  include StudiesProgramsHelper

  load_and_authorize_resource :department
  load_and_authorize_resource :studies_program, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('studies_programs.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: StudiesProgram.datatable(self, %w(diploma_title studies_level semesters)) do |p|
                 @prog = p
                 [
                     %{<%= link_to @prog.diploma_title, studies_program_path(@prog) %>},
                     p.studies_level_text,
                     p.semesters,
                     p.courses.count,
                     programme_status(p.status),
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_studies_program_path(@prog) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), studies_program_path(@prog), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.studies_program.other'), department_studies_programs_path(params[:department_id])
    add_breadcrumb I18n.t('studies_programs.new.title')

    @department = Department.find(params[:department_id])
    @studies_program = @department.studies_programs.build

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.studies_program.other'), department_studies_programs_path(params[:department_id])
    add_breadcrumb I18n.t('studies_programs.new.title')

    @department = Department.find(params[:department_id])
    @studies_program = @department.studies_programs.build(studies_program_params)

    if @studies_program.save
      flash[:notice] = t('mongoid.success.studies_programs.create', title: @studies_program.diploma_title)
      redirect_to edit_studies_program_path(@studies_program)
    else
      render :edit
    end
  end

  def show
    @studies_program = StudiesProgram.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.studies_program.other'), department_studies_programs_path(@studies_program)
    add_breadcrumb I18n.t('studies_programs.show.title')

    @courses = @studies_program.courses
  end

  def edit
    @studies_program = StudiesProgram.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.studies_program.other'), department_studies_programs_path(@studies_program.department)
    add_breadcrumb I18n.t('studies_programs.edit.title')
  end

  def update
    @studies_program = StudiesProgram.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.studies_program.other'), department_studies_programs_path(@studies_program.department)
    add_breadcrumb I18n.t('studies_programs.edit.title')

    if @studies_program.update_attributes(studies_program_params)
      flash[:notice] = I18n.t('mongoid.success.studies_programs.update')
      redirect_to department_studies_programs_path(@studies_program.department)
    else
      render :edit
    end
  end

  def destroy
    @studies_program = StudiesProgram.find(params[:id])

    respond_to do |format|
      if @studies_program.destroy
        message = I18n.t('mongoid.success.studies_programs.destroy', title: @studies_program.diploma_title)
        format.html { redirect_to department_students_path(@student.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.studies_programs.destroy', title: @studies_program.diploma_title)
        format.html { render :edit, alert: message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private
  def studies_program_params
    params.require(:studies_program).permit(:studies_level, :diploma_title, :semesters, :fees, :orientation, :status)
  end
end

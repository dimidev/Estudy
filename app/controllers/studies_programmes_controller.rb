class StudiesProgrammesController < ApplicationController
  include StudiesProgrammesHelper

  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('studies_programmes.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: StudiesProgramme.datatable(self, %w(diploma_title studies_level semesters)) do |p|
                 @prog = p
                 [
                     p.diploma_title,
                     I18n.t("enumerize.studies_programme.studies_level.#{p.studies_level}"),
                     p.semesters,
                     active_status(p.active),
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_studies_programme_path(@prog) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), studies_programme_path(@prog), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.studies_programme.other'), department_studies_programmes_path(params[:department_id])
    add_breadcrumb I18n.t('studies_programmes.new.title')

    @department = Department.find(params[:department_id])
    @studies_programme = @department.studies_programmes.build

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.studies_programme.other'), department_studies_programmes_path(params[:department_id])
    add_breadcrumb I18n.t('studies_programmes.new.title')

    @department = Department.find(params[:department_id])
    @studies_programme = @department.studies_programmes.build(studies_programme_params)

    if @studies_programme.save
      flash[:notice] = t('mongoid.success.models.studies_programme.create', title: @studies_programme.diploma_title)
      redirect_to department_studies_programmes_path(params[:department_id])
    else
      flash[:alert] = t('mongoid.errors.models.studies_programme.create')
      render :edit
    end
  end

  def edit
    @studies_programme = StudiesProgramme.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.studies_programme.other'), department_studies_programmes_path(@studies_programme.department)
    add_breadcrumb I18n.t('studies_programmes.edit.title')
  end

  def update
    @studies_programme = StudiesProgramme.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.studies_programme.other'), department_studies_programmes_path(@studies_programme.department)
    add_breadcrumb I18n.t('studies_programmes.edit.title')

    if @studies_programme.update_attributes(studies_programme_params)
      flash[:notice] = I18n.t('mongoid.success.models.studies_programme.update')
      redirect_to department_studies_programmes_path(@studies_programme.department)
    else
      flash[:alert] = I18n.t('mongoid.errors.models.studies_programme.update')
      render :edit
    end
  end

  def destroy
    @studies_programme = StudiesProgramme.find(params[:id])

    respond_to do |format|
      if @studies_programme.destroy
        message = I18n.t('mongoid.success.models.studies_programme.destroy', title: @studies_programme.diploma_title)
        format.html { redirect_to department_students_path(@student.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.models.studies_programme.destroy', title: @studies_programme.diploma_title)
        format.html { render :edit, alert: message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private
  def studies_programme_params
    params.require(:studies_programme).permit(:studies_level, :diploma_title, :semesters, :fees, :orientation, :active,
                                              programme_rules_attributes: [:id, :_destroy, :course_type, :operator, :value])
  end
end

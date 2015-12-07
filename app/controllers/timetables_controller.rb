class TimetablesController < ApplicationController
  load_and_authorize_resource :department
  load_and_authorize_resource :timetable, through: :department, shallow: true

  def index
    add_breadcrumb I18n.t('timetables.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.find(params[:department_id]).timetables.datatable(self, %w(period from to)) do |timetable|
          [
              %{<%= link_to timetable.period, timetable_path(timetable) %>},
              timetable.from.strftime('%d-%m-%Y'),
              timetable.to.strftime('%d-%m-%Y'),
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_timetable_path(timetable) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), timetable_path(timetable), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(params[:department_id])
    add_breadcrumb I18n.t('timetables.new.title')

    @department = Department.find(params[:department_id])
    @timetable = @department.timetables.build

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(params[:department_id])
    add_breadcrumb I18n.t('timetables.new.title')
    @department = Department.find(params[:department_id])
    @timetable = @department.timetables.build(timetable_params)

    if @timetable.save
      redirect_to department_timetables_path(@timetable.department), notice: t('mongoid.success.timetables.create', title: @timetable.period)
    else
      render :edit
    end
  end

  def show
    @timetable = Timetable.find(params[:id])
    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(@timetable.department)
    add_breadcrumb I18n.t('timetables.show.title')
  end

  def current
    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(params[:department_id])
    add_breadcrumb I18n.t('timetables.current.title')

    @timetable = Department.find(params[:department_id]).timetables.current

    if @timetable
      render :show
    else
      redirect_to department_timetables_path(params[:department_id]), notice: I18n.t('mongoid.errors.timetables.current.not_exists')
    end
  end

  def edit
    @timetable = Timetable.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(@timetable.department)
    add_breadcrumb I18n.t('timetables.edit.title')

    unless @timetable.current?
      redirect_to :back, alert: I18n.t('mongoid.errors.timetables.cannot_edit')
    end
  end

  def update
    @timetable = Timetable.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.timetable.other'), department_timetables_path(@timetable.department)
    add_breadcrumb I18n.t('timetables.edit.title')

    if @timetable.update_attributes(timetable_params)
      flash[:notice] = I18n.t('mongoid.success.timetables.update', title: @timetable.period)
      redirect_to department_timetables_path(@timetable.department)
    else
      render :edit
    end
  end

  def destroy
    @timetable = Timetable.find(params[:id])

    respond_to do |format|
      if @timetable.destroy
        message = I18n.t('mongoid.success.timetables.destroy', title: @timetable.period)

        format.html { redirect_to department_students_path(@timetable.department), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.timetables.destroy')
        format.html { render :edit, alert: message }
        format.js { flash.now[:alert] = message }
      end
    end
  end

  private
  def timetable_params
    params.require(:timetable).permit(:period, :from, :to,
                                      child_timetables_attributes:[:id, :_destroy, :title, :type, :from, :to])
  end
end

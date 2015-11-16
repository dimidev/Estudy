class HallsController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.hall.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Building.find(params[:building_id]).halls.datatable(self, %w(name type area floors seats pc)) do |hall|
          [
              hall.name,
              hall.type_text,
              hall.floor,
              "#{hall.area} m<sup>2</sup>",
              hall.seats,
              hall.pc,
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_hall_path(hall) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), hall_path(hall), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.hall.other'), building_halls_path(params[:building_id])
    add_breadcrumb I18n.t('halls.new.title')

    @building = Building.find(params[:building_id])
    @hall = @building.halls.build

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.hall.other'), building_halls_path(params[:building_id])
    add_breadcrumb I18n.t('halls.new.title')

    @building = Building.find(params[:building_id])
    @hall = @building.halls.build(hall_params)

    if @hall.save
      redirect_to building_halls_path(@hall.building), notice: I18n.t('mongoid.success.halls.create', name: @hall.name)
    else
      render :edit
    end
  end

  def view_all
    add_breadcrumb I18n.t('mongoid.models.hall.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Hall.datatable(self, %w(name type area floors seats pc)) do |hall|
          [
              hall.name,
              hall.type_text,
              hall.building.name,
              hall.floor,
              "#{hall.area} m<sup>2</sup>",
              hall.seats,
              hall.pc,
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_hall_path(hall) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), hall_path(hall), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def edit
    @hall = Hall.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.hall.other'), building_halls_path(@hall.building)
    add_breadcrumb I18n.t('halls.edit.title')

    render :edit
  end

  def update
    @hall = Hall.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.hall.other'), building_halls_path(@hall.building)
    add_breadcrumb I18n.t('halls.edit.title')

    if @hall.update_attributes(hall_params)
      redirect_to building_halls_path(@hall.building), notice: I18n.t('mongoid.success.halls.update', name: @hall.name)
    else
      render :edit
    end
  end

  def destroy
    @hall = Hall.find(params[:id])

    respond_to do |format|
      if @hall.destroy
        message = I18n.t('mongoid.success.halls.destroy', name: @hall.name)
        format.html { redirect_to buildings_halls_path(@hall.building), notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.halls.destroy')
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def hall_params
    params.require(:hall).permit(:name, :type, :area, :floor, :pc, :seats)
  end
end

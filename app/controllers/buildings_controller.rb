class BuildingsController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.building.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Building.datatable(self, %w(name area floors)) do |building|
          [
              building.name,
              "#{building.area} m<sup>2</sup>",
              building.floors,
              building.halls.count,
              %{<div class="btn-group">
                  <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                  <ul class="dropdown-menu dropdown-center">
                    <% if can? :read, Hall %>
                      <li><%= link_to fa_icon('building-o', text: I18n.t('mongoid.models.hall.other')), building_halls_path(building) %></li>
                    <% end %>
                    <% if can? [:update, :destroy], Building %>
                      <li class='divider'></li>
                      <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_building_path(building) %></li>
                      <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), building_path(building), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                    <% end %>
                  </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.building.other'), buildings_path
    add_breadcrumb I18n.t('buildings.new.title')

    @building = Building.new

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.building.other'), buildings_path
    add_breadcrumb I18n.t('buildings.new.title')

    @building = Building.new(building_params)

    if @building.save
      redirect_to buildings_path, notice: I18n.t('mongoid.success.buildings.create', name: @building.name)
    else
      render :edit
    end
  end

  def edit
    add_breadcrumb I18n.t('mongoid.models.building.other'), buildings_path
    add_breadcrumb I18n.t('buildings.edit.title')

    @building = Building.find(params[:id])

    render :edit
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.building.other'), buildings_path
    add_breadcrumb I18n.t('buildings.edit.title')

    @building = Building.find(params[:id])

    if @building.update_attributes(building_params)
      redirect_to buildings_path, notice: I18n.t('mongoid.success.buildings.update', name: @building.name)
    else
      render :edit
    end
  end

  def destroy
    @building = Building.find(params[:id])

    respond_to do |format|
      if @building.destroy
        message = I18n.t('mongoid.success.buildings.destroy', name: @building.name)
        format.html { redirect_to buildings_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.buildings.destroy', name: @building.name)
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def building_params
    params.require(:building).permit(:name, :area, :floors,
                                     address_attributes: [:country, :city, :postal_code, :address])
  end
end

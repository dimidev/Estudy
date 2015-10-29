class DepartmentsController < ApplicationController
  include DepartmentsHelper

  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.department.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Department.datatable(self, %w(title foundation_date)) do |department|
                 [
                     department.title,
                     department.foundation_date,
                     active_status(department.active),
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('users', text: I18n.t('mongoid.models.admin.admins')), department_admins_path(department) %></li>
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
    add_breadcrumb I18n.t('mongoid.models.department.other'), :departments_path
    add_breadcrumb I18n.t('departments.new.title')

    @department = Institution.first.departments.build
    @department.build_address

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.department.other'), :departments_path
    add_breadcrumb I18n.t('departments.new.title')

    @department = Institution.first.departments.build(department_params)

    if @department.save
      redirect_to departments_path, notice: I18n.t('mongoid.success.models.department.create', title: @department.title)
    else
      flash[:alert] = I18n.t('mongoid.errors.models.department.create')
      render :edit
    end
  end

  def edit
    add_breadcrumb I18n.t('mongoid.models.department.other'), :departments_path
    add_breadcrumb I18n.t('departments.edit.title')

    @department = Department.find(params[:id])

    render :edit
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.department.other'), :departments_path
    add_breadcrumb I18n.t('departments.edit.title')

    @department = Department.find(params[:id])

    if @department.update_attributes(department_params)
      redirect_to departments_path, notice: I18n.t('mongoid.success.models.department.update', title: @department.title)
    else
      flash[:alert] = I18n.t('mongoid.errors.models.department.update')
      render :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.destroy
        message = I18n.t('mongoid.success.models.department.destroy', title: @department.title)
        format.html { redirect_to departments_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.models.department.destroy', title: @department.title)
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def department_params
    params.require(:department).permit(:department_logo, :title, :foundation_date, :active,
                                       address_attributes: [:country, :city, :postal_code, :address],
                                       contacts_attributes: [:id, :_destroy, :type, :value])
  end
end

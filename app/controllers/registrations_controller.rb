class RegistrationsController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.index.title')

    respond_to do |format|
      format.html
      format.json do
        render(json: Student.find(params[:student_id]).registrations.datatable(self, %w(id)) do |registration|
                 [
                     registration.id,
                     %{<div class="btn-group">
                        <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                        <ul class="dropdown-menu dropdown-center">
                          <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_registration_path(registration) %></li>
                          <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), registration_path(registration), method: :delete, remote: true, data:{confirm: 'Are you sure ?'} %></li>
                        </ul>
                      </div>}
                 ]
               end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.new.title')

    @student = Student.find(params[:student_id])
    @registration = @student.registrations.build
    @courses = Course.all

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.new.title')

    @student = Student.find(params[:student_id])
    @registration = @student.registrations.build(registration_params)

    if @registration.save
      redirect_to student_registrations_path(params[:student_id]), notice: t('mongoid.success.models.registration.create')
    else
      render :edit, alert: t('mongoid.errors.models.registration.create')
    end
  end

  def current
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.current.title')

    # FIXME
    @registration = Student.find(params[:student_id]).registrations.first
    @courses = @registration.course_ids
  end

  def edit
    @registration = Registration.find(params[:id])

    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(@registration.student)
    add_breadcrumb I18n.t('registrations.edit.title')

    @courses = Course.all
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.registration.other'), student_registrations_path(params[:student_id])
    add_breadcrumb I18n.t('registrations.edit.title')

    @registration = Registration.find(params[:id])

    if @registration.update_attributes(registration_params)
      redirect_to student_registrations_path(@registration.student), notice: I18n.t('mongoid.success.models.registration.update')
    else
      @courses = Course.all
      flash[:alert] = I18n.t('mongoid.errors.models.registration.update')
      render :edit
    end
  end

  def destroy
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.destroy
        format.js{flash.now[:notice]= t('mongoid.success.models.registration.destroy')}
      else
        format.js{flash.now[:alert] = t('mongoid.errors.models.registration.destroy')}
      end
    end
  end

  private

  def registration_params
    params.require(:registration).permit(course_ids:[])
  end
end

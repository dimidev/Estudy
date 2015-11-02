class NoticesController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.notice.other')

    respond_to do |format|
      format.html
      format.json do
        render(json: Notice.datatable(self, %w(title target)) do |notice|
          [
              notice.title,
              notice.created_at.strftime('%d-%m-%Y %H:%M:%S'),
              notice.updated_at.strftime('%d-%m-%Y %H:%M:%S'),
              %{<div class="btn-group">
                <%= link_to fa_icon('cog'), '#', class:'btn btn-sm btn-default dropdown-toggle', data:{toggle:'dropdown'} %>
                <ul class="dropdown-menu dropdown-center">
                  <li><%= link_to fa_icon('pencil-square-o', text: I18n.t('datatable.edit')), edit_notice_path(notice) %></li>
                  <li><%= link_to fa_icon('trash-o', text: I18n.t('datatable.delete')), notice_path(notice), method: :delete, remote: true, data:{confirm: I18n.t('confirmation.delete')} %></li>
                </ul>
              </div>}
          ]
        end)
      end
    end
  end

  def new
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.new.title')

    @notice = Notice.new
    collections

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.new.title')

    @notice = Notice.new(notice_params)

    if @notice.save
      redirect_to notices_path, notice: I18n.t('mongoid.success.models.notice.create')
    else
      collections
      flash[:alert] = I18n.t('mongoid.errors.models.notice.create')
      render :edit
    end
  end

  def show
    @notice = Notice.find(params[:id])

    respond_to do |format|
      format.html
      format.js{ render 'dashboards/modal_show' }
    end
  end

  def edit
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.edit.title')

    @notice = Notice.find(params[:id])
    collections

    render :edit
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.edit.title')

    @notice = Notice.find(params[:id])

    if @notice.update_attributes(notice_params)
      redirect_to notices_path, notice: I18n.t('mongoid.success.models.notice.update')
    else
      collections
      flash[:alert] = I18n.t('mongoid.errors.models.notice.update')
      render :edit
    end
  end

  def destroy
    @notice = Notice.find(params[:id])

    respond_to do |format|
      if @notice.destroy
        message = I18n.t('mongoid.success.models.notice.destroy')
        format.html { redirect_to departments_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.models.notice.destroy')
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def notice_params
    params.require(:notice).permit(:title, :content, :institution_id, :department_id, :admin_id, :professor_id, :student_id)
  end

  def collections
    @departments = Department.active
    @courses = Course.all
    @admins = Admin.all
    @professors = Professor.all
    @students = Student.all
  end
end

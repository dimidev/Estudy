class NoticesController < ApplicationController
  load_and_authorize_resource

  def index
    add_breadcrumb I18n.t('mongoid.models.notice.other')

    if current_user.role? :superadmin
      @notices = Notice.all
    else
      @notices = current_user.department.notices
    end

    respond_to do |format|
      format.html
      format.json do
        render(json: @notices.order_by(updated_at: :desc).datatable(self, %w(title target created_at updated_at)) do |notice|
          [
              %{<%= link_to notice.title, notice_path(notice), remote: true %>},
              notice.target_text,
              (notice.department.title if notice.department.present?),
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

    if current_user.role? :superadmin
      @notice = Notice.new
      @departments = Department.active
    else
      @notice = current_user.department.notices.build
    end

    render :edit
  end

  def create
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.new.title')

    if current_user.role? :superadmin
      @notice = Notice.new(notice_params)
    else
      @notice = current_user.department.notices.build(notice_params)
    end

    if @notice.save
      redirect_to notices_path, notice: I18n.t('mongoid.success.notices.create')
    else
      @departments = Department.active if current_user.role?(:superadmin)
      render :edit
    end
  end

  def show
    @notice = Notice.find(params[:id])

    respond_to do |format|
      format.html
      format.js{ render 'notices/modal_show' }
    end
  end

  def edit
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.edit.title')

    @notice = Notice.find(params[:id])

    @departments = Department.active if current_user.role?(:superadmin)

    render :edit
  end

  def update
    add_breadcrumb I18n.t('mongoid.models.notice.other'), :notices_path
    add_breadcrumb I18n.t('notices.edit.title')

    @notice = Notice.find(params[:id])

    if @notice.update_attributes(notice_params)
      redirect_to notices_path, notice: I18n.t('mongoid.success.notices.update')
    else
      @departments = Department.active if current_user.role?(:superadmin)
      render :edit
    end
  end

  def destroy
    @notice = Notice.find(params[:id])

    respond_to do |format|
      if @notice.destroy
        message = I18n.t('mongoid.success.notices.destroy')
        format.html { redirect_to departments_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.notices.destroy')
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def notice_params
    params.require(:notice).permit(:title, :content, :target, :department_id)
  end
end

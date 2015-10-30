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
              I18n.t("enumerize.notice.target.#{notice.target}"),
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
      redirect_to notices_path, notice: I18n.t('mongoid.success.models.notice.create', target: @notice.target)
    else
      collections
      flash[:alert] = I18n.t('mongoid.errors.models.notice.create')
      render :edit
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
      redirect_to notices_path, notice: I18n.t('mongoid.success.models.notice.update', target: @notice.target)
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
        message = I18n.t('mongoid.success.models.notice.destroy', target: @notice.target)
        format.html { redirect_to departments_path, notice: message }
        format.js { flash.now[:notice] = message }
      else
        message = I18n.t('mongoid.errors.models.notice.destroy', target: @notice.target)
        format.html { render :edit, flash[:alert] = message }
        format.js { flash.now[:notice] = message }
      end
    end
  end

  private
  def notice_params
    params.require(:notice).permit(:title, :content, :target, :institution_id, department_ids:[], admins_ids:[], professor_ids:[], student_ids:[])
  end

  def collections
    @departments = Department.active
    @courses = Course.all
    @admins = Admin.all
    @professors = Professor.all
    @students = Student.all
  end
end

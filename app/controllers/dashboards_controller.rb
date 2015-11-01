class DashboardsController < ApplicationController

  def show
    add_breadcrumb I18n.t('sidebar.dashboard'), :root_path

    if current_user.role? :superadmin
      @students = Student.count
      @adminds = Admin.count
      @professors = Professor.count
    elsif current_user.role? :admin
      @students = current_user.department.students.count
      @admins = current_user.department.admins.count
      @professors = Professor.where(department_id: current_user.department.id).count
    end
  end
end

class DashboardsController < ApplicationController

  def show
    add_breadcrumb I18n.t('sidebar.dashboard'), :root_path

    if current_user.role? :superadmin
      @students = Student.count
      @admins = Admin.count
      @professors = Professor.count
    elsif current_user.role? :admin
      @students = current_user.department.students.count
      @admins = current_user.department.admins.count
      @professors = Professor.where(department_id: current_user.department.id).count
    end

    @institution_notices = Notice.where(target: :institution)

    if current_user.role? :superadmin
      @department_notices = Notice.where(target: :department)
      @admin_notices = Notice.where(target: :admins)
      @professor_notices = Notice.where(target: :professors)
      @student_notices = Notice.where(target: :students)
    elsif current_user.role? :professor
      @department_notices = Notice.or('$and'=> [target: :deaprtments, department_id:{'$ne'=>nil}], '$and'=> [target: :department, department_id:{'$in'=> [current_user.departments]}])
      @admin_notices = Notice.or('$and'=> [target: :admin, department_id:{'$ne'=>nil}], '$and'=> [target: :admins, department_id:{'$in'=> [current_user.departments]}])
      @professor_notices = Notice.or('$and'=> [target: :professors, department_id:{'$ne'=>nil}], '$and'=> [target: :professors, department_id:{'$in'=> [current_user.departments]}])
      @student_notices = Notice.or('$and'=> [target: :students, department_id:{'$ne'=>nil}], '$and'=> [target: :students, department_id:{'$in'=> [current_user.departments]}])
    else
      @department_notices = Notice.or('$and'=> [target: :deaprtments, department_id:{'$ne'=>nil}], '$and'=> [target: :department, department_id: current_user.department])
      @admin_notices = Notice.or('$and'=> [target: :admin, department_id:{'$ne'=>nil}], '$and'=> [target: :admins, department_id: current_user.department])
      @professor_notices = Notice.or('$and'=> [target: :professors, department_id:{'$ne'=>nil}], '$and'=> [target: :professors, department_id: current_user.department])
      @student_notices = Notice.or('$and'=> [target: :students, department_id:{'$ne'=>nil}], '$and'=> [target: :students, department_id: current_user.department])
    end
  end
end

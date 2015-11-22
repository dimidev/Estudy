class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.role? :superadmin
      can :manage, [Institution, Department, Building, Hall]
      can [:show, :update], Superadmin
      can :manage, Admin
      can :manage, Notice
      can :read, [Professor, Student, Registration, Grade]
      can :read, [StudiesProgramme, CourseClass, Timetable, Exam]
    elsif user.role? :admin
      can :read, Institution
      can [:show, :update], Department, id: user.department_id
      can :manage, [Admin, Professor, Student]
      can :manage, [StudiesProgramme, Timetable, CourseClass, Exam, ExamCourse]
      can :manage, [Registration, Grade]
      can :manage, Notice, department_id: user.department_id
      can :manage, [Building, Hall]
    elsif user.role? :professor
      can :read, Institution
      can :manage, Department, id: user.department_id
      can [:show, :edit], Professor
      can :read, CourseClass
      can :read, [StudiesProgramme, Exam]
      can :current, Timetable
      can :read, Notice
    else
      can :read, Institution
      can :show, Department, id: user.department_id
      can [:show, :update], Student, id: user.id
      can :read, CourseClass
      can :manage, Registration
      can :read, StudiesProgramme
      can :current, Timetable
    end
  end
end

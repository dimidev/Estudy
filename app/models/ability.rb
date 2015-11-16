class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.role? :superadmin
      can :manage, [Institution, Department, Building, Hall]
      can [:show, :update], Superadmin
      can :manage, Admin
      can :manage, Notice
      can :read, [Professor, Student, Registration, Grade]
      can :read, [StudiesProgramme, CourseClass, Timetable]
    elsif user.role? :admin
      can [:show, :update], Department, id: user.department_id
      can :manage, [Admin, Professor, Student]
      can :manage, [StudiesProgramme, Timetable, CourseClass, Exam]
      can :manage, [Registration, Grade]
      can :manage, Notice, department_id: user.department_id
      can :manage, [Building, Hall]
    elsif user.role? :professor
      can :manage, Department, id: user.department_id
      can [:show, :edit], Professor
      can :read, CourseClass
      can :read, [StudiesProgramme, Exam]
      can :current, Timetable
      can :read, Notice
    else
      can :show, Department, id: user.department_id
      can :read, Student, id: user.id
      can :read, CourseClass
      can :manage, Registration
      can :read, StudiesProgramme
      can :current, Timetable
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

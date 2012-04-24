require_relative './user'
require_relative './course'

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?

    if user.administrator?
      can :manage, :all
      cannot [:apply, :withdraw], Course
    else
      can [:read, :apply, :withdraw], Course
      can [:read, :apply, :withdraw], Activity
      can [:create], Activity
      can [:choose_teacher], Activity, course: { manager_id: user.id }
      can [:resign], Course, manager_id: user.id
    end
  end
end

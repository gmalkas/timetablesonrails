require_relative './user'
require_relative './course'

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return if user.new_record?

    if user.administrator?
      can :manage, :all
      cannot [:apply, :withdraw, :resign], Course
      cannot [:apply, :withdraw, :resign], Activity
    else
      can [:read, :apply, :withdraw], Course
      can [:read, :apply, :withdraw], Activity
      can [:create], Activity, course: { manager_id: user.id }
      can [:choose_teacher, :dismiss_teacher, :destroy], Activity, course: { manager_id: user.id }
      can [:resign], Course, manager_id: user.id
    end
  end
end

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
    end
  end
end

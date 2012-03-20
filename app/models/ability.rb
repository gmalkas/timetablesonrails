class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.administrator?
      can :manage, :all
      cannot [:apply, :withdraw], Course
    else
      can :read, Course
      can [:apply, :withdraw], Course
    end
  end
end

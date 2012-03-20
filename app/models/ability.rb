class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.administrator?
      can :manage, :all
    else
      can :read, Course
      can :apply, Course
      can :withdraw, Course
    end
  end
end

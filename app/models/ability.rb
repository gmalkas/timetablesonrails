class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.administrator?
      can :manage, :all
    else
      can :read, Course
    end
  end
end

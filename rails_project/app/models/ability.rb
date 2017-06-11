class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.has_role?(:admin)
      can :manage, User
    else
      can :read, User
    end
  end
end



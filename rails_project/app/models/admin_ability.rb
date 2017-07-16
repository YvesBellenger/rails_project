class AdminAbility
  include CanCan::Ability

  #Définition des autorisations pour rails admin
  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
      can :access, :rails_admin
      can :dashboard
    end
  end
end
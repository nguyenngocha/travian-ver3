class AdminAbility
  include CanCan::Ability
  def initialize user
    if user.is_admin?
      can :manage, Proxy
    else
      cannot :manage, :all
    end
  end
end

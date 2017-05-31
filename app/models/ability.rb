class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :lead if user.role? :manager
  end
end

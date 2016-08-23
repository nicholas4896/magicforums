class TopicPolicy < ApplicationPolicy

  def new?
    user.present? && user.admin?
  end

  def create?
    new?
  end

  def edit?
    # binding.pry
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end
end

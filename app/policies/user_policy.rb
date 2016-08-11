class CommentPolicy < ApplicationPolicy

  def new?
    user.present? && user.admin?

  def edit?
    user.present? && record.user == user || user_has_power?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  private

  def user_has_power?
    user.admin? || user.moderator?
  end
end

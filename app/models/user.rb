class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  has_one :preference, dependent: :destroy

  has_many :matches, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :feedback_submissions, dependent: :nullify
  has_many :conversations_as_lower, class_name: "Conversation", foreign_key: :user_lower_id, dependent: :destroy
  has_many :conversations_as_higher, class_name: "Conversation", foreign_key: :user_higher_id, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, dependent: :destroy

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  after_create :assign_default_member_role

  validate :at_least_one_admin_remains

  def self.ransackable_attributes(_auth_object = nil)
    %w[id email phone_number premium status sign_in_count created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[roles user_roles]
  end

  def conversations
    Conversation.for_user(self)
  end

  def admin?
    roles.any?(&:admin?)
  end

  private

  def assign_default_member_role
    member = Role.find_by(key: Role::MEMBER_KEY)
    return unless member

    user_roles.find_or_create_by!(role: member)
  end

  def at_least_one_admin_remains
    admin_role = Role.find_by(key: Role::ADMIN_KEY)
    return unless admin_role && persisted?

    was_admin = UserRole.where(user_id: id, role_id: admin_role.id).exists?
    return unless was_admin
    return if admin?

    others = User.joins(:roles).where(roles: { id: admin_role.id }).where.not(users: { id: id })
    return if others.exists?

    errors.add(:roles, "cannot remove the last administrator")
  end
end

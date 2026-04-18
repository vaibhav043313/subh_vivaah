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

  validate :at_least_one_admin_remains, if: :will_save_change_to_admin?

  def conversations
    Conversation.for_user(self)
  end

  private

  def at_least_one_admin_remains
    return unless admin == false

    other_admins = User.where(admin: true)
    other_admins = other_admins.where.not(id: id) if id
    return if other_admins.exists?

    errors.add(:admin, "cannot be removed — at least one administrator must remain")
  end
end

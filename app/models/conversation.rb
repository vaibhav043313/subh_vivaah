class Conversation < ApplicationRecord
  belongs_to :user_lower, class_name: "User"
  belongs_to :user_higher, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :user_lower_id, comparison: { less_than: :user_higher_id }

  scope :for_user, ->(user) { where("user_lower_id = :id OR user_higher_id = :id", id: user.id) }
  scope :ordered_for_inbox, -> { order(Arel.sql("last_message_at DESC NULLS LAST"), updated_at: :desc) }

  def self.between!(user_a, user_b)
    lo, hi = [ user_a.id, user_b.id ].sort
    find_or_create_by!(user_lower_id: lo, user_higher_id: hi)
  end

  def includes_user?(user)
    user_lower_id == user.id || user_higher_id == user.id
  end

  def other_user(for_user)
    for_user.id == user_lower_id ? user_higher : user_lower
  end

  def unread_count_for(user)
    messages.where.not(sender_id: user.id).where(read_at: nil).count
  end
end

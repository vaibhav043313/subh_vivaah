class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(read_at: nil) }

  def self.deliver_message_received(message)
    recipient = message.conversation.other_user(message.sender)
    return if recipient.blank?

    create!(
      user: recipient,
      actor: message.sender,
      kind: "message",
      title: "New message",
      body: "#{message.sender.profile&.first_name.presence || 'Someone'} sent you a message.",
      notifiable: message
    )
  end

  def self.deliver_profile_view(viewer:, profile:)
    owner = profile.user
    return if owner.id == viewer.id
    return if exists?(user: owner, kind: "profile_view", actor_id: viewer.id, created_at: 1.day.ago..)

    create!(
      user: owner,
      actor: viewer,
      kind: "profile_view",
      title: "Profile visit",
      body: "#{viewer.profile&.first_name.presence || 'A member'} viewed your profile.",
      notifiable: profile
    )
  end

  def mark_read!
    update_column(:read_at, Time.current) if read_at.nil?
  end
end

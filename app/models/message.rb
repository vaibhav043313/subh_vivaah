class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :body, presence: true, length: { maximum: 10_000 }

  before_validation :normalize_body

  after_create_commit :bump_conversation
  after_create_commit :broadcast_to_subscribers

  scope :for_display, -> { order(created_at: :asc) }

  private

  def normalize_body
    self.body = body.to_s.strip
  end

  def bump_conversation
    conversation.update_columns(
      last_message_at: created_at,
      last_message_body: body.truncate(240)
    )
  end

  def broadcast_to_subscribers
    if conversation.messages.count == 1
      broadcast_remove_to conversation, target: "conversation-messages-empty"
    end

    broadcast_append_to(
      conversation,
      target: "conversation-messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end
end

class FeedbackSubmission < ApplicationRecord
  belongs_to :user, optional: true

  CATEGORIES = %w[general bug feature safety billing other].freeze

  validates :body, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validate :email_or_user_present

  private

  def email_or_user_present
    return if user_id.present?
    return if email.to_s.strip.present?

    errors.add(:email, "is required when not signed in")
  end
end

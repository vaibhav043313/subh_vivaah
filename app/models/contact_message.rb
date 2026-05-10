class ContactMessage < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email subject body created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  validates :name, :email, :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end

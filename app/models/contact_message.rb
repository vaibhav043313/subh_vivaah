class ContactMessage < ApplicationRecord
  validates :name, :email, :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end

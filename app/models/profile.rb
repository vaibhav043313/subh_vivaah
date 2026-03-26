class Profile < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 0, female: 1 }
  enum :visibility, { public_profile: 0, private_profile: 1, premium_only: 2 }

  validates :first_name, :date_of_birth, :gender, presence: true
  validates :user_id, uniqueness: true
end

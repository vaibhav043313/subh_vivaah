class Preference < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 0, female: 1 }

  validates :user_id, uniqueness: true
end

class Match < ApplicationRecord
  belongs_to :user
  belongs_to :matched_user, class_name: "User"

  enum :status, { pending: 0, liked: 1, rejected: 2 }
end

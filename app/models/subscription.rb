class Subscription < ApplicationRecord
  belongs_to :user

  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_id plan_key status starts_on ends_on created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end

  scope :active, -> { where(status: "active") }
end

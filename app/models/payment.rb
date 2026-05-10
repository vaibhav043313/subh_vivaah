class Payment < ApplicationRecord
  belongs_to :user

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id user_id amount_cents currency description external_reference plan_name status
      paid_at created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end

  def amount_rupees
    amount_cents / 100.0
  end
end

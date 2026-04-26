# frozen_string_literal: true

class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_id role_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user role]
  end
end

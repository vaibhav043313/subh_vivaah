# frozen_string_literal: true

class Role < ApplicationRecord
  MEMBER_KEY = "member"
  ADMIN_KEY = "admin"

  has_many :user_roles, dependent: :delete_all
  has_many :users, through: :user_roles

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id key name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[users user_roles]
  end

  def self.ensure_defaults!
    find_or_create_by!(key: MEMBER_KEY) { |r| r.name = "Member" }
    find_or_create_by!(key: ADMIN_KEY) { |r| r.name = "Administrator" }
  end

  def self.member
    find_by!(key: MEMBER_KEY)
  end

  def self.admin
    find_by!(key: ADMIN_KEY)
  end

  def admin?
    key == ADMIN_KEY
  end
end

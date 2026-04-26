class BlogPost < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[id title slug excerpt body published_at created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  scope :published, lambda {
    where.not(published_at: nil).where("published_at <= ?", Time.current).order(published_at: :desc)
  }

  validates :title, :slug, :body, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "use lowercase letters, numbers, and hyphens" }

  def to_param
    slug
  end
end

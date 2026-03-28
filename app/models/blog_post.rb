class BlogPost < ApplicationRecord
  scope :published, lambda {
    where.not(published_at: nil).where("published_at <= ?", Time.current).order(published_at: :desc)
  }

  def to_param
    slug
  end
end

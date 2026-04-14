class Profile < ApplicationRecord
  belongs_to :user

  has_many_attached :photos

  enum :gender, { male: 0, female: 1 }
  enum :visibility, { public_profile: 0, private_profile: 1, premium_only: 2 }

  validates :first_name, :date_of_birth, :gender, presence: true
  validates :user_id, uniqueness: true

  before_save :apply_completion_score

  private

  def apply_completion_score
    fields = [ first_name, date_of_birth, gender, religion, profession, city ]
    filled = fields.count(&:present?)
    self.completion_score = (filled.to_f / fields.size * 100).to_i
  end
end

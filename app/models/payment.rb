class Payment < ApplicationRecord
  belongs_to :user

  def amount_rupees
    amount_cents / 100.0
  end
end

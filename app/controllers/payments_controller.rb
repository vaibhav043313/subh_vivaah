class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = current_user.payments.order(Arel.sql("COALESCE(paid_at, created_at) DESC"))
  end
end

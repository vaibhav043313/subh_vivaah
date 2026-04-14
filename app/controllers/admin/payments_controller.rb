# frozen_string_literal: true

module Admin
  class PaymentsController < BaseController
    def index
      scope = Payment.includes(:user).order(created_at: :desc)
      @payments, @total, @page, @total_pages, @per = paginate(scope, per: 40)
    end

    def show
      @payment = Payment.includes(:user).find(params[:id])
    end
  end
end

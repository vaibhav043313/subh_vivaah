# frozen_string_literal: true

module Admin
  class SubscriptionsController < BaseController
    def index
      scope = Subscription.includes(:user).order(created_at: :desc)
      @subscriptions, @total, @page, @total_pages, @per = paginate(scope, per: 40)
    end

    def show
      @subscription = Subscription.includes(:user).find(params[:id])
    end

    def edit
      @subscription = Subscription.find(params[:id])
    end

    def update
      @subscription = Subscription.find(params[:id])
      if @subscription.update(subscription_params)
        redirect_to admin_subscription_path(@subscription), notice: "Subscription updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan_key, :status, :starts_on, :ends_on)
    end
  end
end

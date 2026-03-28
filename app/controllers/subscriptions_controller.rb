class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @subscription = current_user.subscriptions.active.order(Arel.sql("COALESCE(ends_on, created_at) DESC")).first
    @history = current_user.subscriptions.order(created_at: :desc).limit(15)
  end
end

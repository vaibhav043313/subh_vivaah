# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    layout "admin"

    helper AdminHelper

    before_action :authenticate_user!
    before_action :ensure_admin!

    private

    def ensure_admin!
      return if current_user&.admin?

      redirect_to root_path, alert: "You are not authorized to access the admin area."
    end

    def paginate(scope, per: 25)
      total = scope.count
      total_pages = [ (total.to_f / per).ceil, 1 ].max
      page = [ params[:page].to_i, 1 ].max
      page = [ page, total_pages ].min
      offset = (page - 1) * per
      records = scope.limit(per).offset(offset)
      [ records, total, page, total_pages, per ]
    end
  end
end

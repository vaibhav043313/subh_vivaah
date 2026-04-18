# frozen_string_literal: true

module Admin
  class FeedbackSubmissionsController < BaseController
    def index
      scope = FeedbackSubmission.includes(:user).order(created_at: :desc)
      @submissions, @total, @page, @total_pages, @per = paginate(scope, per: 40)
    end

    def show
      @feedback_submission = FeedbackSubmission.includes(:user).find(params[:id])
    end
  end
end

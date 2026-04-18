# frozen_string_literal: true

module Admin
  class ContactMessagesController < BaseController
    def index
      scope = ContactMessage.order(created_at: :desc)
      @messages, @total, @page, @total_pages, @per = paginate(scope, per: 40)
    end

    def show
      @contact_message = ContactMessage.find(params[:id])
    end
  end
end

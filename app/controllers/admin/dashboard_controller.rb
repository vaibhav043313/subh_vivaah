# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    def show
      @counts = {
        users: User.count,
        profiles: Profile.count,
        conversations: Conversation.count,
        messages: Message.count,
        payments: Payment.count,
        subscriptions: Subscription.count,
        notifications: Notification.count,
        blog_posts: BlogPost.count,
        contact_messages: ContactMessage.count,
        feedback_submissions: FeedbackSubmission.count
      }
    end
  end
end

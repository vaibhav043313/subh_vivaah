module ApplicationHelper
  def unread_notifications_count
    return 0 unless user_signed_in?

    current_user.notifications.unread.count
  end

  # Deep link from an in-app notification when we have a known notifiable.
  def notification_action_path(notification)
    case notification.kind
    when "message"
      msg = notification.notifiable
      return unless msg.is_a?(Message)

      conversation_path(msg.conversation)
    when "profile_view"
      prof = notification.notifiable
      return unless prof.is_a?(Profile)

      profile_path(prof)
    end
  end
end

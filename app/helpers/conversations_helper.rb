module ConversationsHelper
  def conversation_path_for_peer(peer_user, fallback_path)
    lo, hi = [current_user.id, peer_user.id].sort
    conv = Conversation.find_by(user_lower_id: lo, user_higher_id: hi)
    conv ? conversation_path(conv) : fallback_path
  end

  def messaging_peer_profile(conversation, viewer)
    conversation.other_user(viewer).profile
  end

  def messaging_peer_thumb(peer_profile)
    if peer_profile.photos.attached?
      url_for(peer_profile.photos.first.variant(resize_to_limit: [96, 96]))
    else
      "https://i.pravatar.cc/96?u=#{peer_profile.user_id}"
    end
  end

  def messaging_time_label(time)
    return "—" if time.blank?

    if time.to_date == Time.zone.today
      time.strftime("%-I:%M %p")
    elsif time > 7.days.ago
      time.strftime("%a %-I:%M %p")
    else
      time.strftime("%d %b %Y")
    end
  end
end

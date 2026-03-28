class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sidebar_data
  before_action :set_conversation, only: [:show]

  def index
    @conversation = nil
  end

  def show
    @messages = @conversation.messages.includes(:sender).for_display
    @peer_profile = @conversation.other_user(current_user).profile
    mark_conversation_read
  end

  def create
    other = User.find_by(id: params[:other_user_id])
    unless other
      redirect_back fallback_location: profiles_path, alert: "Member not found."
      return
    end
    if other.id == current_user.id
      redirect_back fallback_location: profiles_path, alert: "You cannot message yourself."
      return
    end

    conversation = Conversation.between!(current_user, other)
    redirect_to conversation_path(conversation)
  end

  private

  def load_sidebar_data
    rel = current_user.conversations
      .includes(user_lower: { profile: { photos_attachments: :blob } }, user_higher: { profile: { photos_attachments: :blob } })
      .ordered_for_inbox
    if params[:q].present?
      needle = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].strip)}%"
      rel = rel.where("last_message_body ILIKE ?", needle)
    end
    @conversations = rel
    @matches_sidebar = current_user.matches.includes(matched_user: :profile).order(score: :desc).limit(12)
  end

  def set_conversation
    @conversation = current_user.conversations.find_by(id: params[:id])
    redirect_to conversations_path, alert: "Conversation not found." unless @conversation
  end

  def mark_conversation_read
    @conversation.messages.where.not(sender_id: current_user.id).where(read_at: nil).update_all(read_at: Time.current)
  end
end

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params.merge(sender: current_user))
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      redirect_to conversation_path(@conversation), alert: @message.errors.full_messages.to_sentence.presence || "Message could not be sent."
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find_by(id: params[:conversation_id])
    redirect_to conversations_path, alert: "Conversation not found." unless @conversation
  end

  def message_params
    params.require(:message).permit(:body)
  end
end

class PagesController < ApplicationController
  def about
  end

  def contact
    @contact_message = ContactMessage.new
  end

  def create_contact
    @contact_message = ContactMessage.new(contact_params)
    if @contact_message.save
      redirect_to contact_path, notice: "Thank you — we'll get back to you soon."
    else
      render :contact, status: :unprocessable_entity
    end
  end

  def faq
  end

  def terms
  end

  def privacy
  end

  def feedback
    @feedback = FeedbackSubmission.new(category: "general")
  end

  def create_feedback
    @feedback = FeedbackSubmission.new(feedback_params)
    @feedback.user = current_user if user_signed_in?
    @feedback.email = @feedback.email.presence || current_user&.email
    if @feedback.save
      redirect_to feedback_path, notice: "Thanks for your feedback — we read every submission."
    else
      render :feedback, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :body)
  end

  def feedback_params
    params.require(:feedback_submission).permit(:email, :category, :body)
  end
end

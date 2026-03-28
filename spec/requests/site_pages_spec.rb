require "rails_helper"

RSpec.describe "Site pages & billing UI", type: :request do
  %w[/about /contact /faq /terms /privacy /feedback /blog].each do |path|
    it "GET #{path} succeeds" do
      get path
      expect(response).to have_http_status(:success)
    end
  end

  it "POST /contact creates a message" do
    expect do
      post submit_contact_path, params: {
        contact_message: {
          name: "Test User",
          email: "test@example.com",
          subject: "Hello",
          body: "This is a test message for the contact form."
        }
      }
    end.to change(ContactMessage, :count).by(1)
    expect(response).to redirect_to(contact_path)
  end

  it "POST /feedback creates a submission when email given" do
    expect do
      post submit_feedback_path, params: {
        feedback_submission: {
          email: "guest@example.com",
          category: "general",
          body: "Nice site."
        }
      }
    end.to change(FeedbackSubmission, :count).by(1)
    expect(response).to redirect_to(feedback_path)
  end

  context "when signed in" do
    let(:user) { User.create!(email: "member-pages@example.com", password: "password123", password_confirmation: "password123") }

    before { sign_in user, scope: :user }

    it "GET /notifications succeeds" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end

    it "PATCH /notifications/:id/read with JSON marks read without redirect" do
      n = user.notifications.create!(kind: "message", title: "Test", body: "Hi")
      patch read_notification_path(n), headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:no_content)
      expect(n.reload.read_at).to be_present
    end

    it "GET /payments succeeds" do
      get payments_path
      expect(response).to have_http_status(:success)
    end

    it "GET /subscription succeeds" do
      get subscription_path
      expect(response).to have_http_status(:success)
    end

    it "redirects guests from /notifications" do
      sign_out user
      get notifications_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

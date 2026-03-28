require "rails_helper"

RSpec.describe "Conversations & messages", type: :request do
  def create_user_with_profile(email:, first_name: "Test")
    User.create!(
      email: email,
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: first_name,
        last_name: "User",
        date_of_birth: 28.years.ago.to_date,
        gender: :male,
        city: "Jaipur",
        country: "India",
        religion: "Hindu",
        profession: "IT Consultant",
        verified: true,
        has_photo: true
      )
    end
  end

  let(:alice) { create_user_with_profile(email: "alice@example.com", first_name: "Alice") }
  let(:bob) { create_user_with_profile(email: "bob@example.com", first_name: "Bob") }

  describe "authorization" do
    it "redirects guests from conversations index" do
      get conversations_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects guests from creating a conversation" do
      post conversations_path, params: { other_user_id: bob.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "signed in" do
    before { sign_in alice }

    it "renders the inbox" do
      get conversations_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Conversations")
    end

    it "starts a conversation with another member" do
      expect do
        post conversations_path, params: { other_user_id: bob.id }
      end.to change(Conversation, :count).by(1)

      expect(response).to redirect_to(conversation_path(Conversation.last))
      follow_redirect!
      expect(response.body).to include("Bob")
    end

    it "does not allow messaging yourself" do
      expect do
        post conversations_path, params: { other_user_id: alice.id }
      end.not_to change(Conversation, :count)

      expect(response).to have_http_status(:redirect)
    end

    it "posts a message in a thread (Turbo Stream, no full page reload)" do
      conv = Conversation.between!(alice, bob)
      expect do
        post conversation_messages_path(conv),
          params: { message: { body: "Hello from RSpec" } },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end.to change(Message, :count).by(1)

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
      expect(response.body).to include("message-composer-form")
    end

    it "posts a message with HTML accept (redirect fallback)" do
      conv = Conversation.between!(alice, bob)
      post conversation_messages_path(conv),
        params: { message: { body: "Hello HTML" } },
        headers: { "Accept" => "text/html" }

      expect(response).to redirect_to(conversation_path(conv))
      follow_redirect!
      expect(response.body).to include("Hello HTML")
    end

    it "rejects messages to a conversation the user is not in" do
      other = create_user_with_profile(email: "carol@example.com", first_name: "Carol")
      conv = Conversation.between!(bob, other)

      expect do
        post conversation_messages_path(conv), params: { message: { body: "Hack" } }
      end.not_to change(Message, :count)

      expect(response).to redirect_to(conversations_path)
    end
  end
end

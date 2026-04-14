# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account settings", type: :request do
  let(:user) do
    User.create!(
      email: "member@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  before do
    user.create_profile!(
      first_name: "Sam",
      date_of_birth: 28.years.ago.to_date,
      gender: :male,
      country: "India"
    )
    sign_in user
  end

  it "updates profile fields via the profile form" do
    patch user_account_profile_path, params: {
      profile: {
        first_name: "Sam",
        last_name: "Patel",
        date_of_birth: user.profile.date_of_birth,
        gender: "male",
        city: "Mumbai",
        state: "Maharashtra",
        bio: "Hello from tests",
        religion: "Hindu",
        visibility: "public_profile",
        has_photo: "1"
      }
    }

    expect(response).to redirect_to(edit_user_registration_path)
    user.profile.reload
    expect(user.profile.city).to eq("Mumbai")
    expect(user.profile.bio).to eq("Hello from tests")
    expect(user.profile.last_name).to eq("Patel")
  end

  it "re-renders settings when profile is invalid" do
    patch user_account_profile_path, params: {
      profile: {
        first_name: "",
        date_of_birth: user.profile.date_of_birth,
        gender: "male"
      }
    }

    expect(response).to have_http_status(:unprocessable_content)
  end
end

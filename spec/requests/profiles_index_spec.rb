require "rails_helper"

RSpec.describe "Profiles index (listing)", type: :request do
  let(:user) do
    User.create!(
      email: "browser@example.com",
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: "Test",
        last_name: "User",
        date_of_birth: 28.years.ago.to_date,
        gender: :male,
        city: "Mumbai",
        state: "Maharashtra",
        country: "India",
        religion: "Hindu",
        verified: true,
        has_photo: true
      )
    end
  end

  let!(:other) do
    u = User.create!(
      email: "other@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    Profile.create!(
      user: u,
      first_name: "Other",
      last_name: "Member",
      date_of_birth: 26.years.ago.to_date,
      gender: :female,
      city: "Bangalore",
      state: "Karnataka",
      country: "India",
      religion: "Hindu",
      caste: "Brahmin",
      profession: "Software Engineer",
      education: "B.Tech / BE",
      mother_tongue: "Hindi",
      height_cm: 165,
      verified: true,
      has_photo: true,
      completion_score: 70
    )
    u
  end

  it "redirects guests to sign in" do
    get profiles_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "returns success when signed in" do
    sign_in user
    get profiles_path
    expect(response).to have_http_status(:success)
  end

  it "filters by city" do
    sign_in user
    get profiles_path, params: { city: "Bangalore" }
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Other")
  end
end

require "rails_helper"

RSpec.describe "User registration", type: :request do
  it "creates user and profile with nested attributes and redirects to browse" do
    expect do
      post user_registration_path, params: {
        user: {
          email: "newmember@example.com",
          password: "password123",
          password_confirmation: "password123",
          profile_attributes: {
            first_name: "Ada",
            last_name: "Member",
            date_of_birth: 25.years.ago.to_date,
            gender: "female",
            country: "India"
          }
        }
      }
    end.to change(User, :count).by(1).and change(Profile, :count).by(1)

    expect(response).to redirect_to(profiles_path)
    user = User.find_by!(email: "newmember@example.com")
    expect(user.profile.first_name).to eq("Ada")
    expect(user.profile.country).to eq("India")
  end

  it "re-renders sign up when profile is invalid" do
    expect do
      post user_registration_path, params: {
        user: {
          email: "bad@example.com",
          password: "password123",
          password_confirmation: "password123",
          profile_attributes: {
            first_name: "",
            date_of_birth: "",
            gender: ""
          }
        }
      }
    end.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_content)
  end
end

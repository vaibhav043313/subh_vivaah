require "rails_helper"

RSpec.describe "Pricing page", type: :request do
  it "renders membership plans for guests" do
    get pricing_path
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Membership plans")
    expect(response.body).to include("Silver")
    expect(response.body).to include("₹999")
    expect(response.body).to include("₹1,499")
    expect(response.body).to include("₹2,499")
  end

  it "renders for signed-in users" do
    user = User.create!(
      email: "member@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    sign_in user
    get pricing_path
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Browse profiles")
  end
end

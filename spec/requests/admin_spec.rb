# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin area", type: :request do
  def create_user(email:, admin: false)
    User.create!(
      email: email,
      password: "password123",
      password_confirmation: "password123",
      admin: admin
    )
  end

  let(:member) { create_user(email: "member-admin-spec@example.com", admin: false) }
  let(:admin_user) { create_user(email: "admin-spec@example.com", admin: true) }

  it "redirects guests to sign in" do
    get admin_root_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "redirects signed-in non-admins to the home page" do
    sign_in member
    get admin_root_path
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to include("not authorized")
  end

  it "allows admins to open the dashboard" do
    sign_in admin_user
    get admin_root_path
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Dashboard")
  end
end

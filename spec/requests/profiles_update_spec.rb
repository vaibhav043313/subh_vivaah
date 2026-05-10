# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Profiles update (owner, sections)", type: :request do
  let(:owner) do
    User.create!(
      email: "owner@example.com",
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: "Owner",
        last_name: "User",
        date_of_birth: 30.years.ago.to_date,
        gender: :male,
        city: "Pune",
        state: "Maharashtra",
        country: "India",
        religion: "Hindu"
      )
    end
  end

  let(:profile) { owner.profile }

  let(:stranger) do
    User.create!(
      email: "stranger@example.com",
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: "Stranger",
        date_of_birth: 28.years.ago.to_date,
        gender: :female,
        country: "India"
      )
    end
  end

  it "updates basics for signed-in owner" do
    sign_in owner
    patch profile_path(profile), params: {
      section: "basics",
      profile: { first_name: "Updated", last_name: "Member" }
    }
    expect(response).to redirect_to(profile_path(profile))
    expect(profile.reload.first_name).to eq("Updated")
    expect(profile.last_name).to eq("Member")
  end

  it "redirects when another user tries to patch" do
    sign_in stranger
    patch profile_path(profile), params: {
      section: "basics",
      profile: { first_name: "Hax" }
    }
    expect(response).to redirect_to(profiles_path)
    expect(profile.reload.first_name).to eq("Owner")
  end

  it "rejects invalid section" do
    sign_in owner
    patch profile_path(profile), params: {
      section: "nope",
      profile: { first_name: "X" }
    }
    expect(response).to redirect_to(profile_path(profile))
    expect(flash[:alert]).to eq("Invalid section.")
    expect(profile.reload.first_name).to eq("Owner")
  end
end

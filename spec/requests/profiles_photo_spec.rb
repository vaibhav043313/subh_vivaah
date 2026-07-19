# frozen_string_literal: true

require "rails_helper"
require "stringio"
require "base64"

RSpec.describe "Profile photo attachments", type: :request do
  let(:owner) do
    User.create!(
      email: "photoowner@example.com",
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: "Photo",
        last_name: "Owner",
        date_of_birth: 30.years.ago.to_date,
        gender: :male,
        country: "India"
      )
    end
  end

  let(:profile) { owner.profile }

  let(:stranger) do
    User.create!(
      email: "photostranger@example.com",
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

  before do
    tiny_png = Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmH7wAAAABJRU5ErkJggg=="
    )
    profile.photos.attach(
      io: StringIO.new(tiny_png),
      filename: "tiny.png",
      content_type: "image/png"
    )
  end

  it "deletes one photo for the profile owner" do
    sign_in owner
    att_id = profile.photos.attachments.first.id
    expect do
      delete destroy_photo_profile_path(profile, attachment_id: att_id)
    end.to change { profile.reload.photos.attachments.count }.from(1).to(0)

    expect(response).to redirect_to(profile_path(profile))
  end

  it "does not delete for another signed-in user" do
    sign_in stranger
    att_id = profile.photos.attachments.first.id
    expect do
      delete destroy_photo_profile_path(profile, attachment_id: att_id)
    end.not_to(change { profile.reload.photos.attachments.count })

    expect(response).to redirect_to(profiles_path)
  end

  it "handles unknown attachment id" do
    sign_in owner
    delete destroy_photo_profile_path(profile, attachment_id: 999_999_999)
    expect(response).to redirect_to(profile_path(profile))
    expect(flash[:alert]).to eq("Photo not found.")
    expect(profile.reload.photos.attachments.count).to eq(1)
  end

  it "deletes one photo for the profile owner as JSON" do
    sign_in owner
    att_id = profile.photos.attachments.first.id
    expect do
      delete destroy_photo_profile_path(profile, attachment_id: att_id, format: :json)
    end.to change { profile.reload.photos.attachments.count }.from(1).to(0)

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include(
      "message" => "Photo removed.",
      "profile_id" => profile.id,
      "attachment_id" => att_id,
      "remaining_photo_count" => 0
    )
  end

  it "returns forbidden JSON when another signed-in user tries to delete a photo" do
    sign_in stranger
    att_id = profile.photos.attachments.first.id
    expect do
      delete destroy_photo_profile_path(profile, attachment_id: att_id, format: :json)
    end.not_to(change { profile.reload.photos.attachments.count })

    expect(response).to have_http_status(:forbidden)
    expect(response.parsed_body).to eq("error" => "You can only edit your own profile.")
  end

  it "returns not found JSON for an unknown attachment id" do
    sign_in owner
    delete destroy_photo_profile_path(profile, attachment_id: 999_999_999, format: :json)

    expect(response).to have_http_status(:not_found)
    expect(response.parsed_body).to eq("error" => "Photo not found.")
    expect(profile.reload.photos.attachments.count).to eq(1)
  end
end

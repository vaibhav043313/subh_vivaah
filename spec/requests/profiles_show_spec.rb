require "rails_helper"
require "stringio"
require "base64"

RSpec.describe "Profiles show", type: :request do
  let(:viewer) do
    User.create!(
      email: "viewer@example.com",
      password: "password123",
      password_confirmation: "password123"
    ).tap do |u|
      Profile.create!(
        user: u,
        first_name: "Viewer",
        last_name: "User",
        date_of_birth: 29.years.ago.to_date,
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

  let!(:shown) do
    u = User.create!(
      email: "shown@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    Profile.create!(
      user: u,
      first_name: "Priya",
      last_name: "Sharma",
      date_of_birth: 28.years.ago.to_date,
      gender: :female,
      city: "Mumbai",
      state: "Maharashtra",
      country: "India",
      religion: "Hindu",
      caste: "Brahmin",
      profession: "Software Engineer",
      education: "B.Tech Computer Science",
      mother_tongue: "Hindi",
      height_cm: 163,
      income: 8,
      marital_status: "Never Married",
      verified: true,
      has_photo: true,
      completion_score: 80,
      bio: "About this profile."
    )
  end

  let!(:similar_mumbai) do
    u = User.create!(
      email: "similar@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    Profile.create!(
      user: u,
      first_name: "Similar",
      last_name: "Match",
      date_of_birth: 27.years.ago.to_date,
      gender: :female,
      city: "Mumbai",
      state: "Maharashtra",
      country: "India",
      religion: "Hindu",
      verified: true,
      has_photo: true,
      completion_score: 60
    )
  end

  it "redirects guests" do
    get profile_path(shown)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "renders HTML for signed-in users" do
    sign_in viewer
    get profile_path(shown)
    expect(response).to have_http_status(:success)
    expect(response.body).to include("Priya")
    expect(response.body).to include("About me")
    expect(response.body).to include("Similar profiles")
    expect(response.body).to include("Message")
  end

  it "returns JSON when requested" do
    sign_in viewer
    get profile_path(shown), headers: { "Accept" => "application/json" }
    expect(response).to have_http_status(:success)
    expect(response.media_type).to eq(Mime[:json].to_s)
  end

  it "shows section edit modals when viewing your own profile" do
    sign_in shown.user
    get profile_path(shown)
    expect(response.body).to include("profile-edit-basics")
    expect(response.body).to include("Visibility &amp; profile status")
  end

  it "renders photo delete forms outside the photo upload form" do
    tiny_png = Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmH7wAAAABJRU5ErkJggg=="
    )
    shown.photos.attach(
      io: StringIO.new(tiny_png),
      filename: "tiny.png",
      content_type: "image/png"
    )

    attachment_id = shown.photos.attachments.first.id
    sign_in shown.user
    get profile_path(shown)

    dialog = response.body[/<dialog id="profile-edit-photos".*?<\/dialog>/m]
    delete_action = %(action="#{destroy_photo_profile_path(shown, attachment_id: attachment_id)}")
    upload_action = %(action="#{profile_path(shown)}")

    expect(dialog).to include(delete_action)
    expect(dialog).to include(upload_action)
    expect(dialog.index(delete_action)).to be < dialog.index(upload_action)
  end
end

class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def create
    profile = Profiles::CreateProfile.new(current_user, profile_params).call

    render json: profile, status: :created
  end

  def show
    profile = Profile.find_by!(user_id: params[:id])
    render json: profile
  end

  private

  def profile_params
    params.require(:profile).permit(
      :first_name,
      :last_name,
      :date_of_birth,
      :gender,
      :religion,
      :caste,
      :profession,
      :income,
      :city,
      :state,
      :country,
      :bio
    )
  end
end
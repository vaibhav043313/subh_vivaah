# frozen_string_literal: true

module Users
  class AccountProfilesController < ApplicationController
    before_action :authenticate_user!
    layout "auth"

    def update
      @profile = current_user.profile || current_user.build_profile(country: "India")
      if @profile.update(account_profile_params)
        redirect_to edit_user_registration_path, notice: "Profile updated successfully."
      else
        @minimum_password_length = Devise.password_length.min
        render "users/registrations/edit", status: :unprocessable_entity
      end
    end

    private

    def account_profile_params
      params.require(:profile).permit(
        :first_name,
        :last_name,
        :date_of_birth,
        :gender,
        :religion,
        :caste,
        :mother_tongue,
        :marital_status,
        :education,
        :profession,
        :income,
        :height_cm,
        :city,
        :state,
        :country,
        :bio,
        :visibility,
        :has_photo,
        photos: []
      )
    end
  end
end

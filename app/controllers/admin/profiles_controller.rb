# frozen_string_literal: true

module Admin
  class ProfilesController < BaseController
    def index
      scope = Profile.includes(:user).order(updated_at: :desc)
      @profiles, @total, @page, @total_pages, @per = paginate(scope, per: 30)
    end

    def show
      @profile = Profile.includes(:user, photos_attachments: :blob).find(params[:id])
    end

    def edit
      @profile = Profile.find(params[:id])
    end

    def update
      @profile = Profile.find(params[:id])
      if @profile.update(admin_profile_params)
        redirect_to admin_profile_path(@profile), notice: "Profile updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def admin_profile_params
      params.require(:profile).permit(
        :verified,
        :visibility,
        :first_name,
        :last_name,
        :city,
        :state,
        :country,
        :religion,
        :gender
      )
    end
  end
end

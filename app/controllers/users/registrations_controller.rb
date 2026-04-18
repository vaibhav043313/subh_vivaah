module Users
  class RegistrationsController < Devise::RegistrationsController
    layout "auth"

    def new
      build_resource
      resource.build_profile unless resource.profile
      set_minimum_password_length
      respond_with resource
    end

    def edit
      resource.build_profile(country: "India") unless resource.profile
      @profile = resource.profile
      super
    end

    protected

    def after_sign_up_path_for(resource)
      stored_location_for(resource) || profiles_path
    end

    def after_update_path_for(resource)
      stored_location_for(resource) || edit_user_registration_path
    end
  end
end

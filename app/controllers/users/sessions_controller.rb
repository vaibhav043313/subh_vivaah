module Users
  class SessionsController < Devise::SessionsController
    layout "auth"

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || profiles_path
    end
  end
end

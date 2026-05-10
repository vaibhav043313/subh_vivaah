module Profiles
  class CreateProfile
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      profile = @user.build_profile(@params)
      profile.save!
      profile
    end
  end
end

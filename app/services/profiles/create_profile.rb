module Profiles
  class CreateProfile
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      profile = @user.build_profile(@params)

      calculate_completion(profile)

      profile.save!
      profile
    end

    private

    def calculate_completion(profile)
      fields = [
        profile.first_name,
        profile.date_of_birth,
        profile.gender,
        profile.religion,
        profile.profession,
        profile.city
      ]

      filled = fields.compact.count
      profile.completion_score = (filled.to_f / fields.size * 100).to_i
    end
  end
end

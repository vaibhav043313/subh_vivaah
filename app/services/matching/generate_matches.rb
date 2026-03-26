module Matching
  class GenerateMatches
    def self.call(user)
      new(user).call
    end

    def initialize(user)
      @user = user
      @preference = user.preference
    end

    def call
      return unless @preference

      candidates = Profile
        .where(gender: @preference.gender)
        .where(religion: @preference.religion)
        .where(city: @preference.city)
        .where.not(user_id: @user.id)

      candidates.find_each do |profile|
        create_match(profile.user)
      end
    end

    private

    def create_match(matched_user)
      Match.find_or_create_by!(
        user: @user,
        matched_user: matched_user
      ) do |match|
        match.score = calculate_score(matched_user)
      end
    end

    def calculate_score(_matched_user)
      rand(60..100) # placeholder (we improve later)
    end
  end
end

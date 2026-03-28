# frozen_string_literal: true

# Profile listing filters (not an ActiveRecord model).
class BrowseProfilesQuery
  PER_PAGE = 24

  def initialize(params:, current_user:)
    @params = params
    @current_user = current_user
  end

  def relation
    scope = Profile.where.not(user_id: @current_user.id)

    if @params[:q].present?
      raw = @params[:q].to_s.strip
      q = "%#{ApplicationRecord.sanitize_sql_like(raw)}%"
      scope = scope.where(
        "profiles.first_name ILIKE ? OR profiles.last_name ILIKE ? OR CONCAT(profiles.first_name, ' ', COALESCE(profiles.last_name, '')) ILIKE ?",
        q, q, q
      )
    end

    if @params[:age_min].present?
      scope = scope.where("EXTRACT(YEAR FROM AGE(CURRENT_DATE, profiles.date_of_birth))::integer >= ?", @params[:age_min].to_i)
    end

    if @params[:age_max].present?
      scope = scope.where("EXTRACT(YEAR FROM AGE(CURRENT_DATE, profiles.date_of_birth))::integer <= ?", @params[:age_max].to_i)
    end

    if @params[:gender].present? && Profile.genders.key?(@params[:gender])
      scope = scope.where(gender: @params[:gender])
    end

    if @params[:city].present?
      city = "%#{ApplicationRecord.sanitize_sql_like(@params[:city].to_s.strip.downcase)}%"
      scope = scope.where("LOWER(profiles.city) LIKE ?", city)
    end

    if @params[:state].present?
      st = "%#{ApplicationRecord.sanitize_sql_like(@params[:state].to_s.strip.downcase)}%"
      scope = scope.where("LOWER(profiles.state) LIKE ?", st)
    end

    communities = Array(@params[:community]).compact_blank
    scope = scope.where(caste: communities) if communities.any?

    educations = Array(@params[:education]).compact_blank
    scope = scope.where(education: educations) if educations.any?

    occupations = Array(@params[:occupation]).compact_blank
    scope = scope.where(profession: occupations) if occupations.any?

    tongues = Array(@params[:mother_tongue]).compact_blank
    scope = scope.where(mother_tongue: tongues) if tongues.any?

    scope = scope.where(religion: @params[:religion]) if @params[:religion].present?

    if @params[:caste_subcaste].present?
      sub = "%#{ApplicationRecord.sanitize_sql_like(@params[:caste_subcaste].to_s.strip)}%"
      scope = scope.where("profiles.caste ILIKE ?", sub)
    end

    if @params[:height_min_cm].present?
      scope = scope.where("profiles.height_cm IS NOT NULL AND profiles.height_cm >= ?", @params[:height_min_cm].to_i)
    end

    if @params[:height_max_cm].present?
      scope = scope.where("profiles.height_cm IS NOT NULL AND profiles.height_cm <= ?", @params[:height_max_cm].to_i)
    end

    scope = scope.where(verified: true) if ActiveModel::Type::Boolean.new.cast(@params[:verified_only])

    if ActiveModel::Type::Boolean.new.cast(@params[:online_now])
      scope = scope.joins(:user).where("users.last_seen_at > ?", 10.minutes.ago).distinct
    end

    if ActiveModel::Type::Boolean.new.cast(@params[:photo_only])
      scope = scope.where(has_photo: true)
    end

    scope = case @params[:sort]
    when "newest"
              scope.order(created_at: :desc)
    when "age_asc"
              scope.order(date_of_birth: :desc)
    when "age_desc"
              scope.order(date_of_birth: :asc)
    else
              scope.order(completion_score: :desc, created_at: :desc)
    end

    scope.preload(:user)
  end

  def paginated(page:)
    page = page.to_i
    page = 1 if page < 1
    rel = relation
    total = rel.count
    records = rel.offset((page - 1) * PER_PAGE).limit(PER_PAGE).to_a
    [ records, total, page ]
  end

  def self.community_counts
    Profile.where.not(caste: [ nil, "" ]).group(:caste).count
  end
end

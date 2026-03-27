# frozen_string_literal: true

# Suggested profiles for detail page (not an ActiveRecord model).
class SimilarProfilesQuery
  LIMIT = 6

  def initialize(profile, viewer)
    @profile = profile
    @viewer = viewer
  end

  def call
    base = Profile.includes(:user, photos_attachments: :blob)
      .where.not(id: @profile.id)
      .where.not(user_id: @viewer.id)

    ids = []
    add_ids!(ids, base.where(city: @profile.city)) if @profile.city.present?
    add_ids!(ids, base.where(religion: @profile.religion)) if @profile.religion.present? && ids.size < LIMIT
    add_ids!(ids, base.where(profession: @profile.profession)) if @profile.profession.present? && ids.size < LIMIT
    add_ids!(ids, base.where.not(id: ids)) if ids.size < LIMIT

    return Profile.none if ids.empty?

    Profile.where(id: ids)
      .includes(:user, photos_attachments: :blob)
      .in_order_of(:id, ids)
  end

  private

  def add_ids!(ids, scope)
    need = LIMIT - ids.size
    return if need <= 0

    new_ids = scope.where.not(id: ids).order(completion_score: :desc).limit(need).pluck(:id)
    ids.concat(new_ids)
  end
end

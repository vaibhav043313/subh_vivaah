module ProfilesHelper
  def profile_age_years(profile)
    return nil unless profile.date_of_birth

    ((Time.zone.today - profile.date_of_birth).to_i / 365.25).floor
  end

  def profile_match_percent(profile, viewer)
    seed = profile.id * 31 + viewer.id * 7
    55 + (seed % 40)
  end

  def profile_online?(user)
    user.last_seen_at.present? && user.last_seen_at > 10.minutes.ago
  end

  def profile_display_name(profile)
    [ profile.first_name, profile.last_name ].compact_blank.join(" ")
  end

  def profile_location_line(profile)
    parts = [ profile.city, profile.state ].compact_blank
    parts.any? ? parts.join(", ") : nil
  end

  def profile_education_job(profile)
    parts = [ profile.education, profile.profession ].compact_blank
    parts.any? ? parts.join(" • ") : nil
  end

  def profile_new?(profile)
    profile.created_at > 7.days.ago
  end

  def profile_featured?(profile)
    profile.completion_score.to_i >= 75
  end

  def profile_recommended?(profile, viewer)
    profile_match_percent(profile, viewer) >= 80
  end

  def format_filter_count(n)
    n = n.to_i
    return "0" if n <= 0

    n >= 1000 ? format("%.1fk", n / 1000.0) : n.to_s
  end

  # Permitted listing params without given keys; resets to page 1 (filter chip removal).
  def profiles_filters_except(*keys)
    sym_keys = keys.flatten.map(&:to_sym)
    @filter_params.except(*sym_keys, :page).merge(page: 1)
  end

  def profile_detail_value(value)
    value.present? ? value : "—"
  end

  def profile_height_imperial(profile)
    return "—" if profile.height_cm.blank?

    total_inches = profile.height_cm.to_f / 2.54
    feet = (total_inches / 12).floor
    inches = (total_inches % 12).round
    if inches >= 12
      feet += 1
      inches = 0
    end
    %(#{feet}'#{inches}")
  end

  def profile_income_label(profile)
    return "—" if profile.income.blank? || profile.income.to_i <= 0

    lo = profile.income.to_i
    "#{lo}–#{lo + 4} LPA"
  end

  def profile_gallery_sources(profile)
    if profile.photos.attached?
      profile.photos.map do |photo|
        {
          full: url_for(photo.variant(resize_to_limit: [ 880, 880 ])),
          thumb: url_for(photo.variant(resize_to_limit: [ 112, 112 ]))
        }
      end
    else
      u = profile.user_id
      3.times.map do |i|
        seed = u + (i * 10_000)
        {
          full: "https://i.pravatar.cc/800?u=#{seed}",
          thumb: "https://i.pravatar.cc/120?u=#{seed}"
        }
      end
    end
  end

  def profile_similar_thumb_url(profile)
    if profile.photos.attached?
      url_for(profile.photos.first.variant(resize_to_limit: [ 320, 400 ]))
    else
      "https://i.pravatar.cc/320?u=#{profile.user_id}"
    end
  end
end

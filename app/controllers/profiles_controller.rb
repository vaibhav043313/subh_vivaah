class ProfilesController < ApplicationController
  PROFILE_UPDATE_SECTIONS = %w[basics photos about personal career location visibility].freeze

  before_action :authenticate_user!
  before_action :touch_presence, only: [ :index ]
  before_action :require_owned_profile, only: [ :update, :destroy_photo ]

  def index
    @filter_params = permitted_filter_params
    query = ::BrowseProfilesQuery.new(params: @filter_params, current_user: current_user)
    @profiles, @total_count, @page = query.paginated(page: params[:page])
    per = ::BrowseProfilesQuery::PER_PAGE
    @total_pages = [ (@total_count.to_f / per).ceil, 1 ].max
    @community_counts = ::BrowseProfilesQuery.community_counts
    @view_mode = %w[grid list].include?(params[:view]) ? params[:view] : "grid"
    @shown_through = @total_count.zero? ? 0 : [ @page * per, @total_count ].min

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    profile = Profiles::CreateProfile.new(current_user, profile_params).call

    render json: profile, status: :created
  end

  def show
    @profile = Profile.includes(:user, photos_attachments: :blob).find(params[:id])
    @similar_profiles = ::SimilarProfilesQuery.new(@profile, current_user).call
    notify_profile_view_if_viewing_other

    respond_to do |format|
      format.html
      format.json { render json: @profile }
    end
  end

  def destroy_photo
    attachment = @profile.photos.attachments.find_by(id: params[:attachment_id].to_i)
    unless attachment
      redirect_to profile_path(@profile), alert: "Photo not found." and return
    end

    attachment.purge
    redirect_to profile_path(@profile), notice: "Photo removed."
  end

  def update
    section = params[:section].to_s
    unless PROFILE_UPDATE_SECTIONS.include?(section)
      redirect_to(profile_path(@profile), alert: "Invalid section.") and return
    end

    permitted = profile_params_for_section(section)
    if @profile.update(permitted)
      redirect_to profile_path(@profile), notice: "Profile updated."
    else
      flash.now[:alert] = @profile.errors.full_messages.to_sentence
      @similar_profiles = ::SimilarProfilesQuery.new(@profile, current_user).call
      render :show, status: :unprocessable_entity
    end
  end

  private

  def require_owned_profile
    @profile = current_user.profile
    unless @profile&.id == params[:id].to_i
      redirect_to(profiles_path, alert: "You can only edit your own profile.") and return
    end
  end

  def profile_params_for_section(section)
    p = params.fetch(:profile, {})
    case section
    when "basics"
      p.permit(:first_name, :last_name)
    when "photos"
      p.permit(:has_photo, photos: [])
    when "about"
      p.permit(:bio)
    when "personal"
      p.permit(:date_of_birth, :gender, :height_cm, :marital_status, :religion, :caste, :mother_tongue)
    when "career"
      p.permit(:education, :profession, :income)
    when "location"
      p.permit(:city, :state, :country)
    when "visibility"
      p.permit(:visibility)
    else
      {}
    end
  end

  def notify_profile_view_if_viewing_other
    return unless @profile.user_id != current_user.id

    Notification.deliver_profile_view(viewer: current_user, profile: @profile)
  end

  def touch_presence
    current_user.update_column(:last_seen_at, Time.current)
  end

  def permitted_filter_params
    params.except(:commit).permit(
      :q, :age_min, :age_max, :city, :state, :religion, :caste_subcaste, :sort, :view, :page,
      :gender, :height_min_cm, :height_max_cm,
      :photo_only, :online_now, :verified_only,
      community: [], education: [], occupation: [], mother_tongue: []
    )
  end

  def profile_params
    params.require(:profile).permit(
      :first_name,
      :last_name,
      :date_of_birth,
      :gender,
      :religion,
      :caste,
      :profession,
      :income,
      :city,
      :state,
      :country,
      :bio,
      :marital_status,
      :education
    )
  end
end

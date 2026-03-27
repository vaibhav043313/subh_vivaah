class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :touch_presence, only: [:index]

  def index
    if request.format.turbo_stream?
      redirect_to profiles_path(request.query_parameters.except("controller", "action", "commit"))
      return
    end

    @filter_params = permitted_filter_params
    query = ::BrowseProfilesQuery.new(params: @filter_params, current_user: current_user)
    @profiles, @total_count, @page = query.paginated(page: params[:page])
    per = ::BrowseProfilesQuery::PER_PAGE
    @total_pages = [(@total_count.to_f / per).ceil, 1].max
    @community_counts = ::BrowseProfilesQuery.community_counts
    @view_mode = %w[grid list].include?(params[:view]) ? params[:view] : "grid"
    @first_index = @total_count.zero? ? 0 : ((@page - 1) * per) + 1
    @last_index = [@page * per, @total_count].min
  end

  def create
    profile = Profiles::CreateProfile.new(current_user, profile_params).call

    render json: profile, status: :created
  end

  def show
    @profile = Profile.includes(:user, photos_attachments: :blob).find(params[:id])
    @similar_profiles = ::SimilarProfilesQuery.new(@profile, current_user).call

    respond_to do |format|
      format.html
      format.json { render json: @profile }
    end
  end

  private

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

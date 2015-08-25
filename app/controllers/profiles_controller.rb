class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all
    render json: serialized_collection(@profiles)
  end

  def show
    @profile = Profile.find params[:id]
    render json: serialized_object(@profile)
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.update_attributes!(profile_params)
      render json: serialized_object(@profile), status: :created
    else
      render :nothing, status: :bad_request
    end
  end

  def update
    @profile = Profile.find(params[:id])
    # TODO Should not update if given the same ID.
    if @profile.update_attributes!(profile_params)
      render json: serialized_object(@profile), status: :ok
    else
      render :nothing, status: :not_modified
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:place_id, :report_id)
  end

end

class PlacesController < ApplicationController
  def index
    @places = Place.all
    render json: serialized_collection(@places)
  end


  def show
    @place = Place.find params[:id]
    render json: serialized_object(@place)
  end


  def create
    @place = Place.new(place_params)
    if @place.update_attributes!(place_params)
      render json: serialized_object(@place), status: :created
    else
      render :nothing, status: :bad_request
    end
  end


  def update
    @place = Place.find(params[:id])
    if @place.update_attributes!(place_params)
      render json: serialized_object(@place), status: :ok
    else
      render :nothing, status: :not_modified
    end
  end


  private


  def place_params
    params.require(:place).permit(
        :name, :description, :tags,
        :geometry, :user_id, :place_id)
  end
end
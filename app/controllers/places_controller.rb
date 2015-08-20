class PlacesController < ApplicationController
  def index
    @places = Place.all
    json = JSONAPI::Serializer.serialize(
      @places, include: includes, is_collection: true
    )
    json[:links] = paginate @places
    render json: json
  end

  def show
    @place = Place.find params[:id]
    json = JSONAPI::Serializer.serialize(
      @place, include: includes, is_collection: false
    )
    render json: json
  end
end

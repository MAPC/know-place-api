# TODO: More documentation.

class DataCollectionEvaluation

  attr_accessor :data_collection, :place

  def initialize(_d=nil, _p=nil, data_collection: _d, place: _p)
    data_collection && place or raise ArgumentError,
        "Must supply DataCollection and Place objects or ids"
    @data_collection = object_for data_collection, DataCollection
    @place = object_for place, Place
  end

  def valid?
    @data_collection && @place
  end

  def perform
    data = @data_collection.data_points.collect do |data_point|
      DataPointEvaluation.new(
        data_point: data_point,
        place: @place
      ).perform
    end

    # TODO: Create a non-ActiveRecord model for DataCollection evaluations,
    # and serialize them using a JSONAPI Resources wrapper.
    {
      id: @data_collection.id.to_s,
      type: "evaluated-data-collection",
      attributes: {
        title: @data_collection.title
      },
      relationships: { "data-points" => { data: data } }
    }

  end

  private

  # TODO: Dry it up. This is duplicated elsewhere.
  def object_for(object_or_id, klass)
    case object_or_id
    when klass then object_or_id
    when Integer
      klass.find_by(id: object_or_id)
    else
      raise ArgumentError,
        "must provide a #{ klass } or a valid #{ klass } id"
    end
  end
end

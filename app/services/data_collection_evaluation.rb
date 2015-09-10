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
    { data: data }
  end

  private

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
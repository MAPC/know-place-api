class DataPointEvaluation

  attr_accessor :data_point, :place

  def initialize(_d=nil, _p=nil, data_point: _d, place: _p)
    data_point && place or raise ArgumentError,
      "Must supply DataPoint and Place objects or ids"
    @data_point = object_for data_point, DataPoint
    @place      = object_for place,      Place
  end

  def valid?
    @data_point && @place
  end

  def perform
    raw_result = GeographicDatabase.connection.execute to_sql
    result = JSON.parse( raw_result.first['sum_and_moe'] )
    attributes = {
      title:      data_point.name,
      modifier:   data_point.aggregator.modifier,
      aggregator: data_point.aggregator.name,
      value:      result['value'],
      margin:     result['margin']
    }
    data = {
      id: data_point.id.to_s,
      type: 'evaluated-data-point',
      attributes: attributes
    }
  end

  def to_sql
    """
      SELECT #{ @data_point.aggregator.name }(ARRAY[ARRAY[#{ @data_point.fields }]])
      FROM #{ @data_point.tables }
      WHERE geoid IN (#{ @place.geoids.map{|e| "'#{e}'"}.join(",") });
    """
  end

  private

  def object_for(object_or_id, klass)
    case object_or_id
    when klass then object_or_id
    when Integer
      klass.find_by(id: object_or_id)
    else
      raise ArgumentError, "must provide a #{ klass } or a valid #{ klass } id"
    end
  end
end
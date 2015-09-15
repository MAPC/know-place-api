class DataPointEvaluation

  attr_accessor :data_point, :place

  def initialize(_d=nil, _p=nil, data_point: _d, place: _p)
    data_point && place or raise ArgumentError,
      "Must supply DataPoint and Place objects or ids, but got DataPoint: #{data_point.inspect} and Place: #{place.inspect}"
    @data_point = object_for data_point, DataPoint
    @place      = object_for place,      Place
  end

  def valid?
    @data_point && @place
  end

  def perform
    raw_result = GeographicDatabase.connection.execute to_sql
    row = raw_result.first[ @data_point.aggregator.name ]
    # TODO this method is doing too much. There should be a parse method
    # in here doing the extra logic, forming it into a correct object.
    if @data_point.aggregator.name == "sum"
      result = { value: row.to_i, margin: nil }
    else
      result = JSON.parse( row )
    end
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
  rescue JSON::ParserError
    raise StandardError, row.inspect
  end

  def to_sql
    """
      SELECT #{ @data_point.aggregator.name }(#{ @data_point.aggregator.before_fields }#{ @data_point.fields }#{ @data_point.aggregator.after_fields })
      FROM #{ @data_point.tables }
      WHERE geoid IN (#{ @place.geoids.map{|e| "'#{e}'"}.join(",") })
        #{"AND " if @data_point.where}#{ @data_point.where }
      ;
    """.strip
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
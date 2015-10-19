class DataPointEvaluation
  include PgArrayParser

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

  # This method is too long. The attributes and data hashes
  # could easily be refactored into their own methods, as could
  # the parsing of arguments.
  def perform
    result = GeographicDatabase.connection.execute(to_sql).first
    # puts "\n\n#{to_sql}\n\n"
    # puts "\n\n#{result}\n\n"
    agg_variables = @data_point.field_array.map(&:to_sym)

    # Collect fields, ordered to send as arguments
    # into the aggregator function.
    arguments = agg_variables.collect { |var|
      Array(
        parse_pg_array( result[var.to_s] )
      ).map(&:to_i)
    }

    aggregation = AggregatorFunctions.send(
      @data_point.aggregator.name,
      *arguments
    )

    attributes = {
      title:      data_point.name,
      modifier:   data_point.aggregator.modifier,
      aggregator: data_point.aggregator.name,
      units:      data_point.units
    }.merge(aggregation)

    data = {
      id: data_point.id.to_s,
      type: 'evaluated-data-point',
      attributes: attributes
    }
  rescue
    {
      id:   data_point.try(:id),
      type: "evaluated-data-point",
      attributes: {
        value: 0,
        margin: 0,
        units: "error",
        message:  "Data point #{data_point.try(:name)} could not be evaluated.",
        sql: to_sql,
        data_point: data_point.try(:attributes)
      }
    }
  end


  def to_sql
    """
      SELECT #{ @data_point.field_array.map{|f| "array_agg(#{f}) as #{f}" }.join(",") }
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
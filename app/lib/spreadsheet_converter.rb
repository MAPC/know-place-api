class SpreadsheetConverter

  COLLECTION_HEADER = 'Collection'
  TOPIC_AREA_HEADER = 'Topic Area'

  attr_reader :file

  def initialize(spreadsheet_path)
    @spreadsheet_path = spreadsheet_path
    @file = CSV.read spreadsheet_path, 'r', headers: true
  end

  def perform!
    assert_required_fields_present
    # @file.loop_through_and_reject_bad_rows
    @file.each do |row|
      ensure_related_records(row)
      create_data_points_from_row(row)
    end
  end

  private

    def assert_required_fields_present
      spreadsheet_fields = @file.first.to_h.keys
      fields_still_needed = required_fields - spreadsheet_fields
      if fields_still_needed.any?
        raise IOError, """
          The spreadsheet given is missing the following fields:
          #{fields_still_needed.join(',')}.
        """
      end
    end

    def create_data_points_from_row(row)
      units = [
        {
          name:  :estimate,
          units:      row['Estimate Units'],
          aggregator: row['Estimate Aggregator'],
          fields:     row['Estimate Fields']
        },
        {
          name:   :percent,
          units:      row['Percent Units'],
          aggregator: row['Percent Aggregator'],
          fields:     row['Percent Fields']
        }
      ]
      units.each { |unit|
        create_data_point_from_row(row, unit)
      }
    end

    def create_data_point_from_row(row, unit)
      # Skip if there's no unit text for that type
      units    = unit.fetch(:units)
      agg_name = unit.fetch(:aggregator)
      fields   = unit.fetch(:fields)

      if units.nil? || agg_name.nil?
        return
      else
        # puts "\n\nCreating data point with \n\trow: #{row}\n\tunit: #{unit}"
      end

      name = row.fetch('Datapoint')
      table = row.fetch('Table')

      aggregator = Aggregator.find_by(name: agg_name)

      data_point = DataPoint.new(
        name:   name,
        tables: table,
        fields: fields,
        aggregator: aggregator,
        units: units
      )
      if data_point.valid?
        data_point.save
      else
        raise StandardError, "#{data_point.errors.full_messages}\n\n#{data_point.inspect}\n\n#{row}"
      end
      associate_related_records(data_point, row)
    end

    def related_records(row)
      collection = row.fetch(COLLECTION_HEADER) { raise "No column with header #{COLLECTION_HEADER} in row\n#{row}" }
      topic_area = row.fetch(TOPIC_AREA_HEADER) { raise "No column with header #{TOPIC_AREA_HEADER} in row\n#{row}" }
      [collection, topic_area]
    end

    def ensure_related_records(row)
      collection, topic = related_records(row)
      DataCollection.create(title: collection) unless DataCollection.find_by(title: collection).present?
      Topic.create(title: topic) unless Topic.find_by(title: topic).present?
    end

    def associate_related_records(object, row)
      collection, topic = related_records(row)
      DataCollection.find_by(title: collection).data_points << object
      Topic.find_by(title: topic).data_points << object
    end

    def required_fields
      ['Topic Area', 'Collection', 'Datapoint', 'Table', 'Subset Est',
       'Subset MOE', 'Universe Est', 'Universe MOE', 'Estimate Units',
       'Percent Units', 'Estimate Aggregator', 'Percent Aggregator',
       'Estimate Fields', 'Percent Fields']
    end


end
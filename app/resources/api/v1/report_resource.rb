module API
  module V1
    class ReportResource < JSONAPI::Resource

      attributes :title, :description, :tags, :official

      filters :search

      # TODO: Update JR, move to new syntax.
      def self.apply_filter(records, filter, value, options)
        case filter
        when :search
          q = value.first
          return q ? records.search(q) : records
        else
          return super(records, filter, value)
        end
      end

      has_many :data_points
      has_many :data_collections

    end
  end
end

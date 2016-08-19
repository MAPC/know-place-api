module API
  module V1
    class PlaceResource < JSONAPI::Resource

      attributes :name, :municipality, :description, :tags, :geometry,
                 :completed, :underlying, :geoids, :current_user

      filters :search

      has_one :user
      has_one :profile

      def current_user
        context && context[:current_user]
      end

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

      def self.updatable_fields(context)
        super - [:underlying, :municipality]
      end

      def self.creatable_fields(context)
        super - [:underlying, :municipality]
      end

    end
  end
end

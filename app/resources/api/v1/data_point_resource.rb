module API
  module V1
    class DataPointResource < JSONAPI::Resource

      attributes :name, :units

      def evaluation
        { value: nil, margin: nil }
      end

      def self.updatable_fields(context)
        super - [:evaluation]
      end

      def self.creatable_fields(context)
        super - [:evaluation]
      end

    end
  end
end

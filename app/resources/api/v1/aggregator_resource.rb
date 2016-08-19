module API
  module V1
    class AggregatorResource < JSONAPI::Resource

      attributes :name, :modifier, :description, :return_type

    end
  end
end

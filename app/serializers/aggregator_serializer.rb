class AggregatorSerializer < ApplicationSerializer
  def id
    object.to_param.to_s
  end

  attribute :name do
    object.name
  end

  attribute :modifier do
    object.modifier
  end

  attribute :description do
    object.description
  end

  attribute :type do
    object.return_type
  end
end
class DataPointSerializer < ApplicationSerializer
  def id
    object.to_param.to_s
  end

  attribute :name do
    object.name
  end

  attribute :evaluation do
    { value: nil, margin: nil }
  end
end
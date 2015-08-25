class PlaceSerializer < ApplicationSerializer
  def id
    object.to_param.to_s
  end

  attribute :name do
    object.name
  end

  attribute :description do
    object.description
  end

  attribute :geometry do
    object.geometry
  end
end
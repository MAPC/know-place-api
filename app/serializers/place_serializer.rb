class PlaceSerializer < ApplicationSerializer
  def id
    object.to_param.to_s
  end

  def name
    object.name
  end

  def description
    object.description
  end

  def geometry
    object.geometry
  end
end
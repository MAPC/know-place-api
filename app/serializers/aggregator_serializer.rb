class AggregatorSerializer < ApplicationSerializer
  def id
    object.to_param.to_s
  end

  def name
    object.name
  end

  def modifier
    object.modifier
  end

  def description
    object.description
  end
end
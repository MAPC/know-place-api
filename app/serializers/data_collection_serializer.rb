class DataCollectionSerializer < ApplicationSerializer

  has_many :data_points

  def id
    object.to_param.to_s
  end

  def name
    object.name
  end

  def ordered_data_points
    """When DataPoints are included,
      should show data points with order attached"""
  end
end
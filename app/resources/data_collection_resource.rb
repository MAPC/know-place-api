class DataCollectionResource < JSONAPI::Resource
  attribute :title
  has_many :data_points

  def ordered_data_points
    """When DataPoints are included,
      should show data points with order attached"""
  end
end

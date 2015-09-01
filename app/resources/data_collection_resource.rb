class DataCollectionResource < JSONAPI::Resource
  attribute :name

  def ordered_data_points
    """When DataPoints are included,
      should show data points with order attached"""
  end
end

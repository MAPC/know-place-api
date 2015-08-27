require "test_helper"

class DataPointTest < ActiveSupport::TestCase
  def data_point
    @data_point ||= data_points(:total)
    @data_point.fields = [fields(:pop25), fields(:pop25_me), fields(:bapl), fields(:bapl_me)]
    @data_point
  end

  def test_valid
    assert data_point.valid?, data_point.errors.full_messages
  end

  def test_relates_to_fields
    assert_respond_to data_point, :fields
  end

  def test_relates_to_data_collections
    assert_respond_to data_point, :data_collections
    assert_equal DataCollection::ActiveRecord_Associations_CollectionProxy, data_point.data_collections.class
  end
end

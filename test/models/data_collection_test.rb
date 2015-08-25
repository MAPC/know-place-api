require "test_helper"

class DataCollectionTest < ActiveSupport::TestCase
  def data_collection
    @data_collection ||= data_collections(:race)
  end

  def test_valid
    assert data_collection.valid?, data_collection.errors.full_messages
  end

  def test_requires_a_title
    data_collection.title = ""
    assert_not data_collection.valid?
  end

  def test_requires_a_title_of_certain_length
    data_collection.title = "lol"
    assert_not data_collection.valid?
    data_collection.title = "1" * 71
    assert_not data_collection.valid?
  end

  def test_relates_to_data_points
    assert_respond_to data_collection, :data_points
    assert_equal DataPoint::ActiveRecord_Associations_CollectionProxy, data_collection.data_points.class
  end

  # def test_validates_that_ordered_points_are_related
  #   skip "Set up HABTM according to http://api.rubyonrails.org/classes/ActiveRecord/FixtureSet.html"
  #   assert_not_empty data_collection.data_point_ids, data_collection.inspect
  # end
end

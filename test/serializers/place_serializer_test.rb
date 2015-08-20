require "test_helper"

class PlaceSerializerTest < ActiveSupport::TestCase
  def resource
    @resource ||= places(:dudley)
  end

  # TODO This is duplicated logic that could be included in all
  # of the Serializer tests.
  def serializer
    @serializer ||= JSONAPI::Serializer
  end

  def serialization
    @object ||= serializer.serialize( resource, is_collection: false )
  end

  alias_method :s, :serialization

  def data
    s["data"]
  end

  def attributes
    data["attributes"]
  end

  def test_attributes_not_empty
    assert_not_empty attributes, aggregators(:inc).inspect
  end

  def test_id_is_param
    assert_equal resource.to_param.to_s, data["id"], s
  end

  def test_includes_when_given
    skip "Haven't yet related Place to other models"
    includes = ['creator', 'based_on']
    s = serializer.serialize( resource, include: includes )
    assert_equal ['creator', 'based_on'], s["includes"].keys
  end
end

require "test_helper"

class AggregatorSerializerTest < ActiveSupport::TestCase
  def resource
    @resource ||= aggregators(:inc)
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

  def test_does_not_include_sql
    assert_not_includes attributes.keys, "sql"
    assert_not_includes attributes.keys, "function"
    assert_not_includes attributes.keys, "to_function"
    assert_not_includes attributes.keys, "function_definition"
    assert_not_includes attributes.keys, "to_function_definition"
  end
end

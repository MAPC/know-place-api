require "test_helper"

class AggregatorSerializerTest < ActiveSupport::TestCase
  include JsonApiSerializerHelper
  include Common::TestJsonApiConventions

  def resource
    @resource ||= aggregators(:inc)
  end

  def test_does_not_include_sql
    # TODO not technically JSON keys
    refute_json_keys attributes,
      ["sql", "function", "to_function",
       "function_definition", "to_function_definition"]
  end
end

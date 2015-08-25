require "test_helper"

class PlaceSerializerTest < ActiveSupport::TestCase
  include JsonApiSerializerHelper
  include Common::TestJsonApiConventions

  def resource
    @resource ||= places(:dudley)
  end

  # def test_includes_when_given
  #   skip "Haven't yet related Place to other models"
  #   includes = ['creator', 'based_on']
  #   s = serializer.serialize( resource, include: includes )
  #   assert_equal ['creator', 'based_on'], s["includes"].keys
  # end
end

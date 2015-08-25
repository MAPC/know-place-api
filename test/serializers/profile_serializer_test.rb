require "test_helper"

class ProfileSerializerTest < ActiveSupport::TestCase
  include JsonApiSerializerHelper
  include Common::TestJsonApiConventions

  def resource
    @resource ||= profiles(:dtod)
  end

  def test_title
    assert_equal resource.title, attributes['title']
  end

  # def test_includes_when_given
  #   skip "Haven't yet related Place to other models"
  #   includes = ['creator', 'based_on']
  #   s = serializer.serialize( resource, include: includes )
  #   assert_equal ['creator', 'based_on'], s["includes"].keys
  # end
end

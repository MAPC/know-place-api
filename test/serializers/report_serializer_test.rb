require "test_helper"

class ReportSerializerTest < ActiveSupport::TestCase
  include JsonApiSerializerHelper
  include Common::TestJsonApiConventions

  def resource
    @resource ||= reports(:tod)
  end

  def test_includes_when_given
    # skip "Haven't yet related Report to other models"
    # includes = ['creator', 'based_on', 'report_elements']
    # s = serializer.serialize( resource, include: includes )
    # assert_equal ['creator', 'based_on', 'report_elements'], s["includes"].keys
  end
end

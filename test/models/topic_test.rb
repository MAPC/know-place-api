require "test_helper"

class TopicTest < ActiveSupport::TestCase
  def topic
    @topic ||= Topic.new
  end

  def test_valid
    assert topic.valid?
  end
end

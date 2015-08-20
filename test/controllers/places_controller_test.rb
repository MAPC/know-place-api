require "test_helper"

class PlacesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
    body = JSON.parse(@response.body)
    assert_json_keys body, [:data, :links, :included]
    assert_json_keys body["data"][0], :id
    assert_equal "places", body["data"][0]["type"]
  end

  def test_show
    get :show, id: 1
    assert_response :success
    body = JSON.parse(@response.body)
    assert_json_keys body, [:data, :included]
    assert_json_keys body["data"], :id
    assert_equal "places", body["data"]["type"]
  end

  def test_index_with_filter
    skip "Haven't yet implemented filters."
  end

  def test_index_with_includes
    skip "Haven't yet implemented includes."
  end

  def test_search
    skip "Haven't yet implemented searching."
  end

end
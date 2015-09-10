require "test_helper"

class ReportsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, id: reports(:tod).id
    assert_response :success
  end

  def test_search
    get :index, filter: { search: 'trans' }
    assert_response :ok
    assert_equal 1, JSON(@response.body)['data'].count
  end

  def test_empty_search
    get :index, filter: { search: '' }
    assert_response :ok
    assert JSON.parse(response.body)['data'].count > 0
  end

  # def test_index_with_filter
  #   skip "Haven't yet implemented filters."
  # end

  # def test_index_with_includes
  #   skip "Haven't yet implemented includes."
  # end

  # def test_search
  #   skip "Haven't yet implemented searching."
  # end

end

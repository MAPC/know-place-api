require "test_helper"

class PlacesControllerTest < ActionController::TestCase
  def place
    @place ||= places(:dudley)
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, id: place.id
    assert_response :success
  end

  def test_create
    attrs = place.attributes
    attrs['geometry'] = attrs['geometry'].to_json

    post :create, place: attrs
    assert_response :created
  end

  def test_create_with_invalid_data
    # Becomes a Bad Request "with no effort"
    # => http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
    assert_raise( ActionController::ParameterMissing ) {
      post :create, place: {}
    }
  end

  def test_update
    post :update, id: place.id, place: {name: "West Roxbury"}
    assert_response :ok
  end

  def test_update_with_invalid
    assert_raise { post :update, id: place.id, place: {name: ""} }
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
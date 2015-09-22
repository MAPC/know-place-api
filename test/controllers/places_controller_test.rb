require "test_helper"

class PlacesControllerTest < ActionController::TestCase
  include Common

  def setup
    JSONAPI.configuration.raise_if_parameters_not_allowed = true
  end

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
    set_content_type_header!
    post :create,
         {
           data: {
             type: 'places',
             attributes: {
               name: place.name,
               description: place.description,
               geometry: place.geometry.to_json
             }
           }
         }
    assert_response :created
  end

  def test_create_with_invalid_data
    set_content_type_header!
    post :create, place: {}
    assert_response :bad_request
  end

  def test_update
    set_content_type_header!
    p = places(:saved)
    patch :update, id: p.id, data: { id: p.id, type: 'places', attributes: {name: "West Roxbury"} }
    assert_response :ok
  end

  def test_update_with_invalid
    set_content_type_header!
    patch :update, id: place.id, data: { id: place.id, type: 'places', attributes: {name: "A"*71 } }
    assert_response :unprocessable_entity
  end

  def test_make_complete
    set_content_type_header!
    p = Place.create(name: "Inman Square", description: "It's got some nice restaurants, for sure.", geometry: places(:dudley).geometry)
    patch :update, id: p.id, data: { id: p.id, type: 'places', attributes: {completed: 'true'} }
    assert p.reload.completed, @response.body.inspect
  end

  def test_search
    get :index, filter: { search: 'bos' }
    assert_response :ok
    assert_equal 3, JSON.parse(response.body)['data'].count
  end

  def test_empty_search
    get :index, filter: { search: '' }
    assert_response :ok
    assert JSON.parse(response.body)['data'].count > 0, response.body
  end

  def user
    @user ||= users(:exist)
  end

  test "context" do
    @request.headers['Authorization'] = "Token token=#{user.token}, email=#{user.email}"
    get :show, id: place.id
    assert_includes response.body, "current-user"
    assert_includes response.body, user.email
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
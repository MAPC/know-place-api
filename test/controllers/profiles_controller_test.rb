require "test_helper"

class ProfilesControllerTest < ActionController::TestCase
  include Common

  def profile
    @profile ||= profiles(:dtod)
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, id: profile.id
    assert_response :success
  end

  def test_create
    skip
    set_content_type_header!
    post :create, data: { type: 'profiles',
      attributes: {},
      relationships: {
        report: {data: { type: 'reports', id: reports(:tod).id }},
        place:  {data: { type: 'places',  id: places(:dudley).id }}
      }
    }
    assert_response :success, response.body
  end

  def test_create_invalid
    set_content_type_header!
    post :create
    assert_response :bad_request
  end

  def test_update
    set_content_type_header!
    patch :update, id: profile.id, data: {
     id: profile.id,
     type: 'profiles',
      relationships: {
        report: {data: { type: 'reports', id: reports(:demo).id }},
      }
    }
    assert_response :success
  end

  def test_update_with_same_id
    skip
    set_content_type_header!
    patch :update, id: profile.id, data: {
      id: profile.id,
      type: 'profiles',
      relationships: {
        report: {data: { type: 'reports', id: profile.report.id }}
      }
    }
    assert_response :success, response.body
  end

  def test_update_invalid_field
    set_content_type_header!
    patch :update, id: profile.id, data: {
      id: profile.id,
      type: 'profiles',
      attributes: { title: "hello" }
    }
    assert_response :bad_request
  end

  def test_update_invalid_data
    set_content_type_header!
    patch :update, id: profile.id, data: {
      id: profile.id,
      type: 'profiles',
      relationships: {
        place: {data: { type: 'reports', id: profile.report.id }}
      }
    }
    assert_response :bad_request
  end

  def test_filter_on_complete
    get :index, "filter['complete']"
    assert_response :ok, response.inspect
    ids = JSON.parse(response.body)['data'].map{|i| i['id']}
    assert_not_includes ids, profiles(:incomplete).id
  end

end

require "test_helper"

class ProfilesControllerTest < ActionController::TestCase
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
    post :create, profile: profile.attributes
    assert_response :success
  end

  def test_create_invalid
    assert_raise { post :create }
  end

  def test_update
    post :update, id: profile.id, profile: { report_id: reports(:demo).id }
    assert_response :success
  end

  def test_update_with_same_id
    get :update, id: profile.id, profile: { report_id: profile.report.id }
    assert_response :success
    # TODO Should not update if given the same ID.
    # assert_response :not_modified
  end

  def test_update_invalid
    assert_raise { post :update, id: profile.id }
  end

end

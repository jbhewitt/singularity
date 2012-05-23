require 'test_helper'

class HumenControllerTest < ActionController::TestCase
  setup do
    @human = humen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:humen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create human" do
    assert_difference('Human.count') do
      post :create, human: { avatar: @human.avatar, city: @human.city, gamername: @human.gamername, meetup_id: @human.meetup_id, meetup_url: @human.meetup_url, name: @human.name, state: @human.state }
    end

    assert_redirected_to human_path(assigns(:human))
  end

  test "should show human" do
    get :show, id: @human
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @human
    assert_response :success
  end

  test "should update human" do
    put :update, id: @human, human: { avatar: @human.avatar, city: @human.city, gamername: @human.gamername, meetup_id: @human.meetup_id, meetup_url: @human.meetup_url, name: @human.name, state: @human.state }
    assert_redirected_to human_path(assigns(:human))
  end

  test "should destroy human" do
    assert_difference('Human.count', -1) do
      delete :destroy, id: @human
    end

    assert_redirected_to humen_path
  end
end

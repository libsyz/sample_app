require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:bender)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should redirect index when not logged in" do
    # go to page index route via GET
    get users_url
    # should assert redirection to some other page
    assert_redirected_to login_url

  end

  test "should not allow to patch admin value" do
  log_in_as @user
  assert_not @user.admin?
  patch user_path(@user), params: {
                                user: { password: "locloc",
                                        password_confirmation: "locloc",
                                        admin: true } }

  assert_not @user.reload.admin?
  end

  test "should redirect destroy when NOT logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as nonadmin" do
    assert_no_difference 'User.count' do
      log_in_as @user
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end
end



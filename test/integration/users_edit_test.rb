
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:bender)
  end



  test 'should handle successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: {
      user: {
        name: "Miguel",
        email: "derek@valid.com",
        password: "",
        password_confirmation: "" } }
    @name_control = @user.name
    @user.reload
    assert_equal("Miguel", @user.name)

    assert_redirected_to root_path

    assert_not flash.empty?
  end

  test 'unsuccessful edit' do

    log_in_as @user
    get edit_user_path(@user)

    assert_template 'users/edit'
    #Introduce the wrong data
    patch user_path(@user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "nope",
        password_confirmation: "nip" } }

    #Make sure that the template is re-rendered
    assert_template 'users/edit'
    assert_select '.alert.alert-danger'
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
      assert_not flash.empty?
      assert_redirected_to login_url
    end

  test 'should redirect edit when logged in as wrong user' do
    #log in as a otheruser
    log_in_as(@other_user)
    #go to the edit page of user
    get edit_user_path(@user)
    #ensure redirection
    assert_redirected_to root_url

  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
    assert_redirected_to root_url
  end

  end

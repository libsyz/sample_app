require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "check if sign up form rejects invalid info" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: { name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar",
        }}
      end

      assert_template 'users/new'
      assert_select '#error_explanation'
      assert_select '.alert.alert-danger'
    end

    test "signup form should accept valid info" do
      get signup_path
      assert_difference 'User.count' do
        post users_path, params: {user: { name: "Miguel",
          email: "user@valid.com",
          password: "foobar",
          password_confirmation: "foobar",
          }}
        end

      follow_redirect!
      assert_not flash.nil?


      end


    end


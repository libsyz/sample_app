require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "locointhecoco", email: "sample@sample.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.update_attributes(name: "something")
    assert @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@going.com"
    assert_not @user.valid?
  end

  test "username should not be too long" do
    @user.name = "a" * 50
    assert_not @user.valid?
  end

  test "email validation should only accept valid
  email addresses" do
  valid_addresses = %w[user@example.com USER@foo.COM
   first.last@foo.jp alice+bob@baz.cn]
   valid_addresses.each do |valid_address|
    @user.email = valid_address
    assert @user.valid?, "#{valid_address.inspect} should be valid"
  end
end


test "email validation should reject invalid
email addresses" do
invalid_addresses = %w[userexamplecom user_at_foo.org
  foo@bar+baz.com]
  invalid_addresses.each do |invalid_address|
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "emails should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not  duplicate_user.valid?, "duplicate_user email is #{duplicate_user.email}
                                        // @user email is #{@user.email}"
  end

  test "email should be downcased before saving" do
    email = "THIS@THAT.COM"
    @user.email = email
    @user.save
    assert_equal email.downcase, @user.reload.email
  end

  test "password should be 6 characters minimum" do
    password = "5" * 5
    @user.password = @user.password_confirmation = password
    @user.save
    assert_not @user.valid?
  end

end



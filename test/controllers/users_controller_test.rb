require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @configuration = configurations(:one)
    @auth_headers = {
      'Authorization' => ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'password')
    }
  end

  test "should register a new user on registration" do
    post register_users_path, params: { user: { name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password' } }
    assert_response :created
    assert_equal 'User registered successfully', JSON.parse(response.body)['message']
  end

  test "should return errors for invalid registration params" do
    post register_users_path, params: { user: { name: '', email: 'invalid_email', password: 'short', password_confirmation: 'short' } }
    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body)['errors'], "Email is invalid"
  end

  test "should credit points to user's account" do
    purchase_amount = 100.0
    post credit_user_path(@user), params: { purchase_amount: purchase_amount }, headers: @auth_headers
    assert_response :success
    assert_equal @user.reload.points_balance, JSON.parse(response.body)['new_balance']
    assert_equal 50.0, JSON.parse(response.body)['points_earned']
  end

  test "should return errors for zero or negative credit amount" do
    post credit_user_path(@user), params: { purchase_amount: 0 }, headers: @auth_headers
    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body)['errors'], "Purchase amount must be greater than 0"
  end

  test "should debit points from user's account" do
    @user.update(points_balance: 2000.0)
    redemption_amount = 50.0
    post debit_user_path(@user), params: { redemption_amount: redemption_amount }, headers: @auth_headers
    assert_response :success
    assert_equal @user.reload.points_balance, JSON.parse(response.body)['new_balance']
    assert_equal 62.5, JSON.parse(response.body)['points_deducted']
  end

  test "should return error because minimum points should greater than 1000" do
    post debit_user_path(@user), params: { redemption_amount: 10.0 }, headers: @auth_headers
    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body)['errors'], "Minimum points requirement not met: 1000 points"
  end
end

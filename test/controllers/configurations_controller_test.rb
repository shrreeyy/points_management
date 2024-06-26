require 'test_helper'

class ConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
    @configuration = configurations(:one)
    @auth_headers = {
      'Authorization' => ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password')
    }
  end

  test "should show configuration" do
    get configurations_path, headers: @auth_headers
    assert_response :success
    assert_not_nil response.body
  end

  test "should update configuration" do
    post configurations_path, params: { configuration: { earn_ratio: 2.0, burn_ratio: 1.2 } }, headers: @auth_headers
    assert_response :created
    assert_equal 'Configurations updated successfully', JSON.parse(response.body)['message']
  end

  test "should not update configuration with invalid params" do
    post configurations_path, params: { configuration: { earn_ratio: -1, burn_ratio: 0.8 } }, headers: @auth_headers
    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body)['errors'], "Earn ratio must be greater than or equal to 0"
  end
end

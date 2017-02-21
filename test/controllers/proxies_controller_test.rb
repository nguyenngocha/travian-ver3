require 'test_helper'

class ProxiesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get proxies_create_url
    assert_response :success
  end

end

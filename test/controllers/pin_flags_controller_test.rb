require "test_helper"

class PinFlagsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get pin_flags_create_url
    assert_response :success
  end
end

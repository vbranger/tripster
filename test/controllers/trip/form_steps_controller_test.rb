require "test_helper"

class Trip::FormStepsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get trip_form_steps_show_url
    assert_response :success
  end

  test "should get update" do
    get trip_form_steps_update_url
    assert_response :success
  end
end

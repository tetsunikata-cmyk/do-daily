require "test_helper"

class RoadmapsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get roadmaps_show_url
    assert_response :success
  end
end

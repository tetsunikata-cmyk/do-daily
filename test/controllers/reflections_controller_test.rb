require "test_helper"

class ReflectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reflections_index_url
    assert_response :success
  end
end

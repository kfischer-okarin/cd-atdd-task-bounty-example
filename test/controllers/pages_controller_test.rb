require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login if not logged in" do
    get root_path

    assert_redirected_to login_url
  end
end

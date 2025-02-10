require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should not create user with duplicate name" do
    User.create!(name: "duplicate_name")

    assert_no_difference("User.count") do
      post users_path, params: { user: { name: "duplicate_name" } }
    end

    assert_response :unprocessable_entity
  end

  test "should not login with non-existing user" do
    post login_path, params: { name: "non_existing_user" }

    assert_response :unprocessable_entity
  end
end

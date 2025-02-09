require "application_system_test_case"

class PostBountyTest < ApplicationSystemTestCase
  test "WIP: Posted bounties appear in the open task list" do
    given_a_user "Bob"
    given_a_user "Alice"

    as "Bob" do
      post_a_bounty "Fix the login page", bounty: 40
    end

    as "Alice" do
      should_see_open_task "Fix the login page", bounty: 40
    end
  end
end

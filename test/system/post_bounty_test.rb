require "application_system_test_case"

class PostBountyTest < ApplicationSystemTestCase
  test "Posted bounties appear in the open task list" do
    given_a_user "Bob"
    given_a_user "Alice"

    as "Bob" do
      post_bounty "Fix the login page", reward: 40
    end

    as "Alice" do
      should_see_open_task "Fix the login page", reward: 40, posted_by: "Bob"
    end
  end

  test "WIP: Users need enough balance to post a bounty" do
    given_a_user "Bob", balance: 30

    as "Bob" do
      cannot_post_bounty "A too expensive bounty", reward: 40, because: "insufficient balance"
    end
  end
end

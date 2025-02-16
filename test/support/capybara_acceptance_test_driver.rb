require_relative "capybara_acceptance_test_driver/capybara_api"

class CapybaraAcceptanceTestDriver
  def initialize(test_case)
    # For accessing the default assertion APIs of Minitest
    @test_case = test_case
    # Access Capybara API through a separate object to avoid polluting the driver with Capybara methods
    @capybara = CapybaraAPI.new(test_case)
  end

  def teardown
    @capybara.teardown
  end

  def create_user(name)
    @capybara.visit "/users/new"
    @capybara.fill_in "Name", with: name
    @capybara.click_on "Create User"
    expect_notification "User was successfully created."
  end

  def login_as(name)
    @capybara.visit "/login"
    @capybara.fill_in "Name", with: name
    @capybara.click_on "Login"
    expect_notification "Successfully logged in."
  end

  def logout
    go_to_dashboard
    @capybara.click_on "Logout"
    expect_notification "Successfully logged out."
  end

  def post_bounty(title:, reward:)
    go_to_dashboard
    @capybara.click_on "Post a Bounty"
    @capybara.fill_in "Title", with: title
    @capybara.fill_in "Reward", with: reward
    @capybara.click_on "Post Bounty"
    expect_notification "Bounty was successfully posted."
  end

  def list_open_bounties
    go_to_dashboard
    open_bounties_headline = @capybara.find("h2", text: "Open Bounties")
    table = open_bounties_headline.sibling("table")
    table.all("tr").map { |row|
      title, reward, posted_by = row.all("td").map(&:text)
      { title: title, reward: reward.to_i, posted_by: posted_by }
    }
  end

  private

  def go_to_dashboard
    @capybara.visit "/"
    @capybara.assert_text "Dashboard"
  end

  def expect_notification(message)
    @capybara.assert_selector ".notification", text: message
  end
end

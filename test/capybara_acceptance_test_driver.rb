require "capybara/dsl"
require "capybara/minitest"

Capybara.configure do |config|
  # If necessary we could probably also set this via an environment variable
  config.default_driver = :selenium_chrome_headless
  config.run_server = false
  config.app_host = ENV["APP_URL"]
end

class CapybaraAcceptanceTestDriver
  class CapybaraAPI
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    # Minitest assertions assume that they are direct instance methods of the test case and can access the assertion
    # count to increment it for the test statistics. Since this object is not a test case, we need to delegate the
    # assertions accessor to the test case.
    delegate :assertions, :assertions=, to: :@test_case

    def initialize(test_case)
      @test_case = test_case
    end
  end

  def initialize(test_case)
    # For accessing the default assertion APIs of Minitest
    @test_case = test_case
    # Access Capybara API through a separate object to avoid polluting the driver with Capybara methods
    @capybara = CapybaraAPI.new(test_case)
  end

  def create_user(name)
    @capybara.visit "/users/new"
    @capybara.fill_in "Name", with: name
    @capybara.click_on "Create User"
    @capybara.assert_text "User was successfully created."
  end

  def login_as(name)
    @capybara.visit "/login"
    @capybara.fill_in "Name", with: name
    @capybara.click_on "Login"
    @capybara.assert_text "Successfully logged in."
  end

  def logout
    go_to_dashboard
    @capybara.click_on "Logout"
    @capybara.assert_text "Successfully logged out."
  end

  def post_bounty(title:, reward:)
    go_to_dashboard
    @capybara.click_on "Post a Bounty"
    @capybara.fill_in "Title", with: title
    @capybara.fill_in "Reward", with: reward
    @capybara.click_on "Post Bounty"
    @capybara.assert_text "Bounty was successfully posted."
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  private

  def go_to_dashboard
    @capybara.visit "/"
    @capybara.assert_text "Dashboard"
  end
end

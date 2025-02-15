require "action_dispatch/system_testing/test_helpers/screenshot_helper"
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
    include ActionDispatch::SystemTesting::TestHelpers::ScreenshotHelper

    # Minitest assertions and screenshot helper assume the class they are included in is a test case and need to
    # access the test case's methods, so we delegate them to the test case
    delegate_missing_to :@test_case

    def initialize(test_case)
      @test_case = test_case
    end
  end
end

require "test_helper"

require_relative "acceptance_test_dsl"
require_relative "capybara_acceptance_test_driver"

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include AcceptanceTestDSL

  setup do
    # If we had several drivers we could use for example an environment variable to select the driver
    # Since we only have one driver, we can hardcode it here for now
    @driver = CapybaraAcceptanceTestDriver.new(self)
  end

  teardown do
    @driver.teardown
  end
end

require "test_helper"

require_relative "support/acceptance_test_dsl"
require_relative "support/capybara_acceptance_test_driver"
require_relative "support/id_alias_map"

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include AcceptanceTestDSL

  def before_setup
    # If we had several drivers we could use for example an environment variable to select the driver
    # Since we only have one driver, we can hardcode it here for now
    @driver = CapybaraAcceptanceTestDriver.new(self)
    @id_alias_map = IdAliasMap.new
  end

  def after_teardown
    @driver.teardown
  end
end

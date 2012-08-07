require File.expand_path('../../test_helper', __FILE__)

require "active_support"
require "mocha"

require "integration/shared_integration_tests"

class ActiveSupportTestUnitTest < ActiveSupport::TestCase
  include SharedIntegrationTests
end

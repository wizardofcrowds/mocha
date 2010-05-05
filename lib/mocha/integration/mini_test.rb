require 'mocha/api'

if !MiniTest::Unit::TestCase.ancestors.include?(Mocha::API)
  
  require 'mocha/integration/mini_test/version_131_and_above'
  
  module MiniTest
    class Unit
      class TestCase
        
        include Mocha::API
        
        # For now workaround a MacRuby bug which makes it impossible to
        # actually remove a method and include a module which defines it again.
        #
        # alias_method :run_before_mocha, :run
        # remove_method :run
        # 
        # include Mocha::Integration::MiniTest::Version131AndAbove
        
      end
    end
  end
end

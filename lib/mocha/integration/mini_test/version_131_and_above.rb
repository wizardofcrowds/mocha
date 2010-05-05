require 'mocha/integration/mini_test/assertion_counter'
require 'mocha/expectation_error'

module MiniTest
  class Unit
    class TestCase
      def self.translate_exception(exception)
        return exception unless exception.kind_of?(::Mocha::ExpectationError)
        translated_exception = ::MiniTest::Assertion.new(exception.message)
        translated_exception.set_backtrace(exception.backtrace)
        translated_exception
      end
      
      def run(runner)
        assertion_counter = ::Mocha::Integration::MiniTest::AssertionCounter.new(self)
        result = '.'
        name = (self.respond_to?(:name) ? self.name : self.__name__)
        begin
          begin
            @passed = nil
            self.setup
            self.__send__ name
            mocha_verify(assertion_counter)
            @passed = true
          rescue Exception => e
            @passed = false
            result = runner.puke(self.class, name, self.class.translate_exception(e))
          ensure
            begin
              self.teardown
            rescue Exception => e
              result = runner.puke(self.class, name, self.class.translate_exception(e))
            end
          end
        ensure
          mocha_teardown
        end
        result
      end
      
    end
  end
end

# For now workaround a MacRuby bug which makes it impossible to
# actually remove a method and include a module which defines it again.
#
# module Mocha
#   
#   module Integration
#     
#     module MiniTest
#       
#       def self.translate(exception)
#         return exception unless exception.kind_of?(::Mocha::ExpectationError)
#         translated_exception = ::MiniTest::Assertion.new(exception.message)
#         translated_exception.set_backtrace(exception.backtrace)
#         translated_exception
#       end
#       
#       module Version131AndAbove
#         def run runner
#           assertion_counter = AssertionCounter.new(self)
#           result = '.'
#           name = (self.respond_to?(:name) ? self.name : self.__name__)
#           begin
#             begin
#               @passed = nil
#               self.setup
#               self.__send__ name
#               mocha_verify(assertion_counter)
#               @passed = true
#             rescue Exception => e
#               @passed = false
#               result = runner.puke(self.class, name, Mocha::Integration::MiniTest.translate(e))
#             ensure
#               begin
#                 self.teardown
#               rescue Exception => e
#                 result = runner.puke(self.class, name, Mocha::Integration::MiniTest.translate(e))
#               end
#             end
#           ensure
#             mocha_teardown
#           end
#           result
#         end
#       end
#       
#     end
#     
#   end
#   
# end

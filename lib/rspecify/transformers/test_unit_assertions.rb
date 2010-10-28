module RSpecify
  module Transformers
    
    # = Test Unit Assertions Transformer
    # Catches instances where Test::Unit assertions are being called (such as assert_equal) and morphs
    # the calls to use the RSpec idiom.
    # 
    class TestUnitAssertions < RubyScribe::Transformer
      def transform(e)
        super sexp?(e) ? transform_test_unit_assertions(e) : e
      end
      
      def transform_test_unit_assertions(e)
        case
        when assert_equals_call?(e)
          transform_assert_equals_call(e)
        else
          e
        end
      end
      
      def assert_equals_call?(e)
        e.kind == :call && e.body[0].nil? && e.body[1] == :assert_equals
      end

      def transform_assert_equals_call(e)
        method_arguments = e.body[2].body

        s(:call,
          s(:call, method_arguments[0], :should, s(:arglist)),
          :==,
          s(:arglist, method_arguments[1])
        )
      end
    end
    
  end
end
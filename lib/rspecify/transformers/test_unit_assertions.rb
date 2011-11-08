module RSpecify
  module Transformers
    
    # = Test Unit Assertions Transformer
    # Catches instances where Test::Unit assertions are being called (such as assert_equal) and morphs
    # the calls to use the RSpec idiom.
    # 
    class TestUnitAssertions < RubyTransform::Transformer
      def transform(e)
        super sexp?(e) ? transform_test_unit_assertions(e) : e
      end
      
      def transform_test_unit_assertions(e)
        case
        when assert_equal_call?(e)
          transform_assert_equal_call(e)
        when assert_not_equal_call?(e)
          transform_assert_not_equal_call(e)
        when assert_not_nil_call?(e)
          transform_assert_not_nil_call(e)
        else
          e
        end
      end
      
      # assert_equal:
      def assert_equal_call?(e)
        e.kind == :call && e.body[0].nil? && e.body[1] == :assert_equal
      end
      def transform_assert_equal_call(e)
        method_arguments = e.body[2].body

        s(:call,
          s(:call, method_arguments[0], :should, s(:arglist)),
          :==,
          s(:arglist, method_arguments[1])
        )
      end

      # assert_not_equal:
      def assert_not_equal_call?(e)
        e.kind == :call && e.body[0].nil? && e.body[1] == :assert_not_equal
      end
      def transform_assert_not_equal_call(e)
        method_arguments = e.body[2].body

        s(:call,
          s(:call, method_arguments[0], :should_not, s(:arglist)),
          :==,
          s(:arglist, method_arguments[1])
        )
      end

      # assert_not_nil:
      def assert_not_nil_call?(e)
        e.kind == :call && e.body[0].nil? && e.body[1] == :assert_not_nil
      end
      def transform_assert_not_nil_call(e)
        method_arguments = e.body[2].body

        s(:call, method_arguments[0], :should_not, 
          s(:arglist, s(:call, nil, :be_nil, s(:arglist)))
        )
      end

    end
    
  end
end

module RSpecify
  class Transformer < RubyScribe::Transformer
    def transform(e)
      super transform_to_rspec(e)
    end
    
    def transform_to_rspec(e)
      return e unless sexp?(e)
      
      case
      when assert_equals_call?(e)
        transform_assert_equals_call(e)
      when assert_true_call?(e)
        transform_assert_true_call(e)
      when assert_false_call?(e)
        transform_assert_false_call(e)
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
    
    def assert_true_call?(e)
      
    end
    
    def transform_assert_true_call(e)
      
    end
    
    def assert_false_call?(e)
      
    end
    
    def transform_assert_false_call(e)
      
    end
  end
end
module RSpecify
  module Transformers
    
    # = Test Class And Methods Transformer
    # Catches instances where a class is being defined extending ActiveSupport::TestClass and converts it into 
    # an RSpec describe block, then converts all methods contained therein beginning with "test_" to 
    # rspec "it" blocks.
    #
    class TestClassAndMethods < RubyTransform::Transformer
      def transform(e)
        super sexp?(e) ? transform_test_class_and_methods(e) : e
      end
      
      def transform_test_class_and_methods(e)
        if e.kind == :class && e.body[1] == s(:colon2, s(:const, :ActiveSupport), :TestCase)
          transform_test_class(e)
        else
          e
        end
      end
      
      def transform_test_class(e)
        name = e.body[0].to_s.gsub /Test$/, ""
        class_body = e.body[2].body[0]
        if class_body.kind == :block
          new_block = Sexp.from_array([:block] + class_body.body.map {|e| transform_test_class_method_definition e })
        else
          new_block = transform_test_class_method_definition class_body
        end
        s(:iter, 
          s(:call, nil, :describe, s(:arglist, s(:const, name.to_sym))),
          nil,
          new_block
        )
      end
      
      def transform_test_class_method_definition(e)
        if e.kind == :defn && e.body[0].to_s.starts_with?("test_") && e.body[1].body.empty?
          test_name = e.body[0].to_s.gsub(/^test_/, "").gsub("_", " ")

          s(:iter,
            s(:call, nil, :it, s(:arglist, s(:str, test_name))),
            nil,
            e.body[2].body[0]
          )
        else
          e
        end
      end
    end
    
  end
end

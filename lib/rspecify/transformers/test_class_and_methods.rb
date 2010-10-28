module RSpecify
  module Transformers
    
    # = Test Class And Methods Transformer
    # Catches instances where a class is being defined extending ActiveSupport::TestClass and converts it into 
    # an RSpec describe block, then converts all methods contained therein beginning with "test_" to 
    # rspec "it" blocks.
    #
    class TestClassAndMethods < RubyScribe::Transformer
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
        s(:iter, 
          s(:call, nil, :describe, s(:arglist, s(:const, e.body[0]))),
          nil,
          transform_test_class_method_definitions(e.body[2].body[0])
        )
      end
      
      def transform_test_class_method_definitions(e)
        Sexp.from_array([e.kind] + e.body.map do |child|
          if child.kind == :defn && child.body[0].to_s.starts_with?("test_") && child.body[1].body.empty?
            transform_test_class_method_definition(child)
          else
            child
          end
        end)
      end
      
      def transform_test_class_method_definition(e)
        test_name = e.body[0].to_s.gsub(/^test_/, "").gsub("_", " ")
        
        s(:iter,
          s(:call, nil, :it, s(:arglist, s(:str, test_name))),
          nil,
          e.body[2].body[0]
        )
      end
    end
    
  end
end

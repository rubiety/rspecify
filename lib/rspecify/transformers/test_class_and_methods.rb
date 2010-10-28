module RSpecify
  module Transformers
    
    # = Test Class And Methods Transformer
    # Catches instances where a class is being defined extending ActiveSupport::TestClass and converts it into 
    # an RSpec describe block, then converts all methods contained therein beginning with "test_" to 
    # rspec "it" blocks.
    #
    class TestClassAndMethods < RubyScribe::Transformer
      
    end
    
  end
end

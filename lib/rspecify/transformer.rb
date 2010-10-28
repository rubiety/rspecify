module RSpecify
  class Transformer < RubyScribe::Transformer
    def dependent_transformers
      [
        RSpecify::Transformers::TestClassAndMethods.new,
        RSpecify::Transformers::TestUnitAssertions.new
      ]
    end
    
    def transform(e)
      super(dependent_transformers.inject(e) {|result, transformer|
        transformer.transform(result)
      })
    end
  end
end
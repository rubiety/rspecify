RSpec::Matchers.define :transform_to do |desc, expected|
  match do |actual|
    actual_as_sexp = actual.is_a?(String) ? RubyParser.new.parse(actual) : actual
    expected_as_sexp = expected.is_a?(String) ? RubyParser.new.parse(expected) : expected
    
    transformer = described_class.is_a?(Class) ? described_class.new : described_class
    @transformed = transformer.transform(actual_as_sexp)
    @transformed == expected_as_sexp
  end
  
  failure_message_for_should do |actual|
    "expected that:\n\n#{RubyParser.new.parse(actual)}\n\nwould transform to:\n\n#{RubyParser.new.parse(expected)}\n\nbut instead was:\n\n#{@transformed}\n\n#{transformed_as_ruby}"
  end

  failure_message_for_should_not do |actual|
    "expected that:\n\n#{RubyParser.new.parse(actual)}\n\nwould not transform to:\n\n#{RubyParser.new.parse(expected)}\n\nbut instead was:\n\n#{@transformed}\n\n#{transformed_as_ruby}"
  end
  
  description do
    "transform with to #{desc}"
  end
  
  def transformed_as_ruby
    RubyScribe::Emitter.new.emit(@transformed) rescue nil
  end
end
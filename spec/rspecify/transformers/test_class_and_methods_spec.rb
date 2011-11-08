require "spec_helper"

describe RSpecify::Transformers::TestClassAndMethods do
  
  describe "class extending ActiveSupport::TestCase" do
    subject { %{
      class MyClass < ActiveSupport::TestCase
        do_something
        something_else
      end
    } }
    
    it { should transform_to("describe block", %{
      describe MyClass do
        do_something
        something_else
      end
    }) }
  end
  
  describe "class extending ActiveSupport::TestCase with Test naming convention" do
    subject { %{
      class MyClassTest < ActiveSupport::TestCase
        do_something
        something_else
      end
    } }

    it { should transform_to("describe block", %{
      describe MyClass do
        do_something
        something_else
      end
    }) }
  end

  describe "class extending ActiveSupport::TestCase with methods" do
    subject { %{
      class MyClass < ActiveSupport::TestCase
        def test_should_be_valid
          something
          1
        end
        
        def test_should_not_be_valid
          something
          1
        end
      end
    } }
    
    it { should transform_to("describe block", %{
      describe MyClass do
        it "should be valid" do
          something
          1
        end
        
        it "should not be valid" do
          something
          1
        end
      end
    }) }
  end

  describe "class extending ActiveSupport::TestCase with alternate method naming" do
    subject { %{
      class MyClass < ActiveSupport::TestCase
        test "should be valid" do
          something
          1
        end
      end
    } }

    it { pending "not yet implemented"
    should transform_to("describe block", %{
      describe MyClass do
        it "should be valid" do
          something
          1
        end
      end
    }) }
  end
  
end

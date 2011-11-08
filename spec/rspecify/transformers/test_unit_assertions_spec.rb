require "spec_helper"

describe RSpecify::Transformers::TestUnitAssertions do
  
  describe "short assert equal" do
    subject { %{assert_equal @one, "One"} }
    it { should transform_to("should ==", %{@one.should == "One"}) }
  end
  
  describe "long assert equal" do
    subject { %{
      assert_equal @organization.people.first, Person.find_by_name_and_organization(
        "Ben, Hughes",
        "RailsGarden"
      )
    } }
    
    it { should transform_to("should == ", %{@organization.people.first.should == Person.find_by_name_and_organization("Ben, Hughes", "RailsGarden")}) }
  end
  
  describe "short assert not equal" do
    subject { %{assert_not_equal @one, "One"} }
    it { should transform_to("should_not ==", %{@one.should_not == "One"}) }
  end

  describe "short assert not nil" do
    subject { %{assert_not_nil @one} }
    it { should transform_to("should_not be_nil", %{@one.should_not(be_nil)}) }
  end
  
end

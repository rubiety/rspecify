require "spec_helper"

describe RSpecify::Transformers::TestUnitAssertions.new do
  
  describe "short assert equals" do
    subject { %{assert_equals @one, "One"} }
    it { should transform_to("should ==", %{@one.should == "One"}) }
  end
  
  describe "long assert equals" do
    subject { %{
      assert_equals @organization.people.first, Person.find_by_name_and_organization(
        "Ben, Hughes",
        "RailsGarden"
      )
    } }
    
    it { should transform_to("should == ", %{@organization.people.first.should == Person.find_by_name_and_organization("Ben, Hughes", "RailsGarden")}) }
  end
  
end

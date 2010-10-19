require "spec_helper"

describe RSpecify::Converter do
  specify do
    %{assert_equals @one, "One"}.should convert_to(%{
      @one.should == "One"
    })
  end
  
  specify do
    %{
      assert_equals @organization.people.first, Person.find_by_name_and_organization(
        "Ben, Hughes",
        "RailsGarden"
      ),
    }.should convert_to(%{
      @organization.people.first.should == Person.find_by_name_and_organization("Ben, Hughes", "RailsGarden")
    })
  end
end

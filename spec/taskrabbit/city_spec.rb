require 'spec_helper'

describe Taskrabbit::City do

  describe "city properties" do

    before :all do
      tr = Taskrabbit::Api.new
      VCR.use_cassette('cities/properties', :record => :none) do
        @city = tr.cities.find(3)
        @city.fetch
      end
    end

    subject { @city }

    its(:id) { should == 3 }
    its(:name) { should == "SF Bay Area" }
    its(:lat) { should be_instance_of(Float) }
    its(:lng) { should be_instance_of(Float) }
    its(:links) { should be_instance_of(Hash) }
  end

  describe "api endpoints" do
    describe "#all" do
      it "should fetch all cities" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('cities/all', :record => :none) do
          cities = nil
          expect { cities = tr.cities }.to_not raise_error
          cities.should == Taskrabbit::City
          cities.count.should > 0
          cities.keys.should =~ ["items", "links"]
          cities.links
          cities.each do |city|
            city.should be_instance_of Taskrabbit::City
          end
        end
      end
    end

    describe "#find" do
      it "should not fetch if not accessing an existing param" do
        tr = Taskrabbit::Api.new
        city = nil
        expect { city = tr.cities.find(3) }.to_not raise_error
        city.id.should == 3
      end

      it "should should fetch the city" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('cities/find', :record => :none) do
          city = nil
          expect { city = tr.cities.find(3) }.to_not raise_error
          city.id.should == 3
          city.name.should == 'SF Bay Area'
        end
      end
    end
  end
end
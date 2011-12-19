require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:each) do
    @client = Rubyhorn.client
  end

  describe "addMediaPackage" do
    it "should return a Workflow object after call to ingest" do
      video = File.new "spec/fixtures/dance_practice.ogx"
      workflow = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "fedora-test"})
      workflow.should be_an_instance_of Rubyhorn::Workflow
      workflow.term_values(:template)[0].should eql "fedora-test"
      workflow.term_values(:mediapackage, :title)[0].should eql "hydrant:13"
      workflow.find_by_terms(:mediapackage, :media, :track)[0]["type"].should eql "presenter/source"
    end
  end
end

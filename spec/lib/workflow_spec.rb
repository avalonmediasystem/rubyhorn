require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:all) do
    @client = Rubyhorn.client
    video = File.new "spec/fixtures/dance_practice.ogx"
    workflow = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "fedora-test"})
    @id = workflow.find_by_terms(:workflow)[0]["id"]
  end

  after(:all) do
    #TODO cleanup by deleting mediapackage and workflow instance?
  end

  describe "instance_xml" do
    it "should return a Workflow object for the given id" do
      workflow = @client.instance_xml @id
      workflow.should be_an_instance_of Rubyhorn::Workflow
      workflow.term_values(:template)[0].should eql "fedora-test"
      workflow.term_values(:mediapackage, :title)[0].should eql "hydrant:13"
      workflow.find_by_terms(:mediapackage, :media, :track)[0]["type"].should eql "presenter/source"
    end
  end
end

require 'spec_helper'

describe Rubyhorn::MatterhornClient do

  before(:all) do
    Rubyhorn.init
    @client = Rubyhorn.client
    @ids = []
  end

  after(:all) do
    @ids.each {|id| @client.stop id}
  end

  describe "addMediaPackage" do
    it "should return a Workflow object after call to ingest" do
      video = File.new "spec/fixtures/dance_practice.ogx"
      workflow_doc = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "hydrant"})
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      @ids << workflow.id[0]
      workflow.template[0].should eql "hydrant"
      workflow.mediapackage.title[0].should eql "hydrant:13"
      workflow.mediapackage.media.track.type[0].should eql "presenter/source"
    end
    it "should be able to rename file uploaded" do
      video = File.new "spec/fixtures/dance_practice.ogx"
      workflow_doc = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "hydrant", "filename" => "video.ogx"})
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      @ids << workflow.id[0]
      workflow.template[0].should eql "hydrant"
      workflow.mediapackage.title[0].should eql "hydrant:13"
      workflow.mediapackage.media.track.type[0].should eql "presenter/source"
      workflow.mediapackage.media.track.url[0].should match "video.ogx"
    end
  end
end

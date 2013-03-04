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
  describe '#addMediaPackageWithUrl' do
    it 'throws an exception when one of the required arguments is not passed' do
      expect {
        @client.addMediaPackageWithUrl({"title" => "hydrant:13", "workflow" => "avalon"}) # missing flavor, url, filename
      }.to raise_error Rubyhorn::RestClient::Exceptions::MissingRequiredParams
    end

    it 'throws an exception when the server returns an http error status code' do
      expect {
        @client.addMediaPackageWithUrl({'title' => 'hydrant:13', 'flavor' => 'presenter/source', 'workflow' => "hydrant", 'url'=> 'http://localhost:8080', 'filename'=>'hi'})
      }.to raise_error Rubyhorn::RestClient::Exceptions::ServerError
    end
  end

  describe "addMediaPackage" do
    it "should return a Workflow object after call to ingest" do
      video = File.new "spec/fixtures/dance_practice.ogx"
      workflow_doc = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "avalon"})
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      @ids << workflow.id[0]
      workflow.template[0].should eql "avalon"
      workflow.mediapackage.title[0].should eql "hydrant:13"
      workflow.mediapackage.media.track.type[0].should eql "presenter/source"
    end
    it "should be able to rename file uploaded" do
      video = File.new "spec/fixtures/dance_practice.ogx"
      workflow_doc = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "avalon", "filename" => "video.ogx"})
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      @ids << workflow.id[0]
      workflow.template[0].should eql "avalon"
      workflow.mediapackage.title[0].should eql "hydrant:13"
      workflow.mediapackage.media.track.type[0].should eql "presenter/source"
      workflow.mediapackage.media.track.url[0].should match "video.ogx"
    end
  end
end

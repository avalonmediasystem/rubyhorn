require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:each) do
    Rubyhorn.init
    @client = Rubyhorn.client
    video = File.new "spec/fixtures/videoshort.mp4"
    workflow = @client.addMediaPackage(video, {"title" => "hydrant:13", "flavor" => "presenter/source", "workflow" => "avalon"})
    @id = workflow.id[0]
#    puts "Created media package with workflow #{@id}: #{workflow.to_xml}"
  end

  describe "instance methods" do
    after(:each) do
      #TODO cleanup by deleting mediapackage and workflow instance?
      @client.stop @id
    end

    describe "instance_xml" do
      it "should return a Workflow object for the given id" do
        workflow_doc = @client.instance_xml @id
        workflow_doc.should be_an_instance_of Rubyhorn::Workflow
        workflow = workflow_doc.workflow
        workflow.template[0].should eql "avalon"
        workflow.mediapackage.title[0].should eql "hydrant:13"
        workflow.mediapackage.media.track.type[0].should eql "presenter/source"
      end
    end

    describe "instances_json" do
      xit "should return a JSON doc with a list of instances that have the state RUNNING" do
        sleep 5
        json = @client.instances_json({"state" => "running"})
        json["workflows"]["totalCount"].to_i.should eq 1
      end
    end
  end

  describe "stop" do
    it "should return a Workflow object of the stopped workflow instance for the given id" do
      workflow_doc = @client.stop @id
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      workflow.id[0].should eql @id
      workflow.state[0].should eql "STOPPED"
      workflow.mediapackage.title[0].should eql "hydrant:13"
    end
  end
end

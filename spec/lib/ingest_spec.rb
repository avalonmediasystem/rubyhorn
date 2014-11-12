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

  describe '#createMediaPackage' do
    it 'should return an empty but initialized media object xml document' do
      mp = @client.createMediaPackage
      expect(mp).to be_an_instance_of Nokogiri::XML::Document
      expect(mp.root.name).to eq 'mediapackage'	
    end
  end

  describe '#addDCCatalog' do
    let(:mediapackage) {@client.createMediaPackage}
    let(:dc) {Nokogiri::XML('<dublincore xmlns="http://www.opencastproject.org/xsd/1.0/dublincore/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dcterms:title>avalon:no-pid</dcterms:title>
</dublincore>')}
    it 'should add a DC catalog' do
      mp = @client.addDCCatalog({'mediaPackage' => mediapackage.to_xml, 'dublinCore' => dc.to_xml, 'flavor' => 'dublincore/episode'})
      
      expect(mp).to be_an_instance_of Nokogiri::XML::Document
      expect(mp.root.name).to eq 'mediapackage'	
      expect(mp.xpath('//xmlns:catalog').size).to eq 1
      expect(mp.xpath('//xmlns:catalog').first['type']).to eq 'dublincore/episode'
    end
  end

  describe '#addTrack' do
    let(:mediapackage) {@client.createMediaPackage}
    let(:url) {"file://" + URI.escape(File.realpath('spec/fixtures/dance_practice.ogx'))}
    it 'should upload the file and add a Track' do
video = File.new "spec/fixtures/dance_practice.ogx"
      mp = @client.addTrack({'mediaPackage' => mediapackage.to_xml, 'url' => url, 'flavor' => 'presenter/source'})
      
      expect(mp).to be_an_instance_of Nokogiri::XML::Document
      expect(mp.root.name).to eq 'mediapackage'	
      expect(mp.xpath('//xmlns:track').size).to eq 1
      expect(mp.xpath('//xmlns:track').first.at('url').text).to match(/\/files\/mediapackage\/.*\/dance_practice.ogx/)
    end
  end

  describe '#ingest' do
    let(:mediapackage) do
      mp = @client.createMediaPackage
      mp = @client.addDCCatalog({'mediaPackage' => mp.to_xml, 'dublinCore' => dc.to_xml, 'flavor' => 'dublincore/episode'})
      mp = @client.addTrack({'mediaPackage' => mp.to_xml, 'url' => url, 'flavor' => 'presenter/source'})
      mp
    end
    let(:dc) {Nokogiri::XML('<dublincore xmlns="http://www.opencastproject.org/xsd/1.0/dublincore/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dcterms:title>avalon:no-pid</dcterms:title>
</dublincore>')}
    let(:url) {"file://" + URI.escape(File.realpath('spec/fixtures/dance_practice.ogx'))}
    it 'should return a workflow document' do
      workflow_doc = @client.ingest({"workflow" => "avalon", "mediaPackage" => mediapackage.to_xml})
      workflow_doc.should be_an_instance_of Rubyhorn::Workflow
      workflow = workflow_doc.workflow
      @ids << workflow.id[0]
      workflow.template[0].should eql "avalon"
      workflow.mediapackage.title[0].should eql "avalon:no-pid"
      workflow.mediapackage.media.track.type[0].should eql "presenter/source"
    end
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

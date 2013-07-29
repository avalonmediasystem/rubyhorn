require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:all) do
    Rubyhorn.init
    @client = Rubyhorn.client
  end

  describe "statistics" do
    it "should retrieve statistics" do
      json = @client.statistics
      json['statistics']['service'].should be_instance_of(Array)
    end

    it "should retrieve a list of registered services" do
      json = @client.services
      json['services']['service'].should be_instance_of(Array)
    end
  end
end
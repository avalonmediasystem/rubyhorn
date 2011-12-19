require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:each) do
    @client = Rubyhorn.client
  end

  describe "me" do
    it "should return a JSON doc with user set to matterhorn_system_account" do
      json = @client.me
      json["username"].should eql "matterhorn_system_account"
    end
  end

  describe "components" do
    it "should return a JSON doc with wadl's for all REST endpoints" do
      json = @client.components
      json["rest"].each { |x| x.keys.should include "wadl" }
#      json["admin"].should eql "http://localhost:8080"
    end
  end
end

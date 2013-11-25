require 'spec_helper'

describe Rubyhorn::MatterhornClient do
  before(:all) do
    Rubyhorn.init
    @client = Rubyhorn.client
  end

  describe "storage" do
    it "should return a JSON doc with useable space on the drive as a Fixnum" do
      json = @client.storage
      json["usable"].should be_a Fixnum
    end
  end
end

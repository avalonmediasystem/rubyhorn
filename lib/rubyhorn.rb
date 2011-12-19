#require 'active-model'

module Rubyhorn
  autoload :MatterhornClient, "rubyhorn/matterhorn_client"
  autoload :Workflow, "rubyhorn/workflow"

  require 'rubyhorn/version'

  # Connect to Opencast Matterhorn
  # @return Rubyhorn::Repository
  def self.connect *args
    @client ||= MatterhornClient.new *args
  end

  # Connect to Opencast Matterhorn using default config
  # @return Rubyhorn::MatterhornClient
  def self.client
    @client ||= self.connect(self.default_config)
  end

  # Set the default Opencast Matterhorn client
  # @param [Rubyhorn::MatterhornClient] client
  # @return Rubyhorn::MatterhornClient
  def self.client= client
    @client = client
  end

  def self.default_config
    {:uri=>'http://localhost:8080/', :user=>'matterhorn_system_account', :password=>'CHANGE_ME'}
  end
end

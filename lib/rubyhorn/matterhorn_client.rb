require 'rubyhorn/rest_client/common'
require 'rubyhorn/rest_client/info'
require 'rubyhorn/rest_client/ingest'
require 'rubyhorn/rest_client/workflow'
require 'rubyhorn/rest_client/exceptions'
require 'rubyhorn/rest_client/distribution'
require 'rubyhorn/rest_client/services'

module Rubyhorn
  class MatterhornClient
    include Rubyhorn::RestClient::Common
    include Rubyhorn::RestClient::Info
    include Rubyhorn::RestClient::Ingest
    include Rubyhorn::RestClient::Workflow
    include Rubyhorn::RestClient::Exceptions
    include Rubyhorn::RestClient::Distribution
    include Rubyhorn::RestClient::Services

    # repository configuration (see #initialize)
    attr_reader :config

    def initialize options = {}
      @config = options
      connect
    end

  end
end

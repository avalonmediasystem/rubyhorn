require 'json'

module Rubyhorn::RestClient
  module Files
    def storage
      return JSON.parse(get("files/storage"))
    end
  end
end
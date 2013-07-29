require 'json'

module Rubyhorn::RestClient
  module Services
    def services
      return JSON.parse(get("services/services.json"))
    end
    
    def statistics
      return JSON.parse(get("services/statistics.json"))
    end
  end
end
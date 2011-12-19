require 'json'

module Rubyhorn::RestClient
  module Info
	#Return ruby object corresponding to JSON returned from info/me.json
	def me
	  return JSON.parse(get("info/me.json"))
	end

	#Return ruby object corresponding to JSON returned from info/components.json
	def components
	  return JSON.parse(get("info/components.json"))
	end
  end
end

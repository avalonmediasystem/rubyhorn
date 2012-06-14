module Rubyhorn::RestClient
  module Workflow
    def handlers
      return JSON.parse(get("workflow/handlers.json"))
    end
    def statistics_json
      return JSON.parse(get("workflow/statistics.json"))
    end
    def statistics_xml
      #TODO write me and parse into OM document or just use Nokogiri?
    end
    def instance_json id
      return JSON.parse(get("workflow/instance/#{id}.json"))
    end
    def instance_xml id
      return Rubyhorn::Workflow.from_xml(get("workflow/instance/#{id}.xml"))
    end
    def stop id
      return Rubyhorn::Workflow.from_xml(post("workflow/stop", {"id"=>id}))
    end
  end
end

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

    def instances_json args
      return JSON.parse(get("workflow/instances.json", args))
    end

    def stop id
      return Rubyhorn::Workflow.from_xml(post("workflow/stop", {"id"=>id}))
    end

    def delete_instance
      return Rubyhorn::Workflow.from_xml(delete("workflow/remove", {"id"=>id}))
    end

    def get_media_package(workflow_id)
      package = Rubyhorn::Workflow.from_xml(get("workflow/instance/#{workflow_id}.xml"))
      doc = Nokogiri.XML(package.to_xml)
      doc.remove_namespaces!
      doc = doc.xpath('//mediapackage')
      first_node = doc.first
      first_node['xmlns'] = 'http://mediapackage.opencastproject.org'
      doc
    end

  end
end

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

    def definition_xml id
      return get("workflow/definition/#{id}.xml")
    end
    
    def definition_json id
      return JSON.parse(get("workflow/definition/#{id}.json"))
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

    def instances_xml args
      return Nokogiri.XML(get("workflow/instances.xml", args))
    end

    def start args
      return Rubyhorn::Workflow.from_xml(post("workflow/start", args))
    end

    def stop id
      return Rubyhorn::Workflow.from_xml(post("workflow/stop", {"id"=>id}))
    end

    def delete_instance id
      return Rubyhorn::Workflow.from_xml(delete("workflow/remove", {"id"=>id}))
    end

    def update_instance xml
      post("workflow/update", {"workflow"=>xml})
    end

    def get_media_package(workflow_id)
      doc = Nokogiri.XML(get("workflow/instance/#{workflow_id}.xml"))
      doc.remove_namespaces!
      doc = doc.xpath('//mediapackage')
      first_node = doc.first
      first_node['xmlns'] = 'http://mediapackage.opencastproject.org'
      doc
    end

    def get_media_package_from_id(media_package_id)
      doc = instances_xml({mp: media_package_id})
      doc.remove_namespaces!
      doc = doc.xpath('//mediapackage')
      first_node = doc.first
      first_node['xmlns'] = 'http://mediapackage.opencastproject.org'
      doc
    end

    def get_stopped_workflow(workflow_id)
      doc = instances_xml({q: workflow_id, state: 'STOPPED'})
      doc.remove_namespaces!
      Rubyhorn::Workflow.from_xml(doc.xpath('//workflow').first)
    end

  end
end

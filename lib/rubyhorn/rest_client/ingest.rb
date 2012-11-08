module Rubyhorn::RestClient
  module Ingest
    def addMediaPackage(file, params)
      raise "Missing required field flavor" unless params.include? "flavor"
      raise "Missing required field title" unless params.include? "title"

      uri = "ingest/addMediaPackage" + (params["workflow"].nil? ? "" : "/#{params["workflow"]}")
      return Rubyhorn::Workflow.from_xml multipart_post(uri, file, params)
    end

    # Adds a mediapackage and starts ingesting, using an URL as the resource
    def addMediaPackageWithUrl(params)
      logger.debug "<<<<< IM IN URL MeTHOd >>>>>"
      
      raise "Missing required field url" unless params.include? "url"
      raise "Missing required field flavor" unless params.include? "flavor"
      raise "Missing required field title" unless params.include? "title"

      uri = "ingest/addMediaPackage" + (params["workflow"].nil? ? "" : "/#{params["workflow"]}")
      return Rubyhorn::Workflow.from_xml post(uri, params)
    end
  end
end

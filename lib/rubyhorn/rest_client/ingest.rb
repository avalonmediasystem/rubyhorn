module Rubyhorn::RestClient
  module Ingest
    def addMediaPackage(file, params)
      raise "Missing required field flavor" unless params.include? "flavor"
      raise "Missing required field title" unless params.include? "title"

      uri = "ingest/addMediaPackage" + (params["workflow"].nil? ? "" : "/#{params["workflow"]}")
      file.define_singleton_method(:original_filename) { 
        params[:filename] || params['filename'] || File.basename(self.path) 
      }
      return Rubyhorn::Workflow.from_xml post(uri, params.merge('BODY'=>file))
    end

    # Adds a mediapackage and starts ingesting, using an URL as the resource
    def addMediaPackageWithUrl(params)
      missing_params = ['url','flavor','title','filename','workflow'].collect{|field| field if ! params.include?(field) }.compact
      raise Rubyhorn::RestClient::Exceptions::MissingRequiredParams.new(missing_params) if missing_params.present?
      uri = "ingest/addMediaPackage"
      uri += "/#{params["workflow"]}" unless params["workflow"].nil?
      Rubyhorn::Workflow.from_xml post(uri, params)
    end
  end
end

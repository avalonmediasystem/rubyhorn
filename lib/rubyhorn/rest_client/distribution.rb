module Rubyhorn::RestClient
  module Distribution

    # Returns the url to the job xml, which can be used to query job's status
    def delete_track( media_package, track_id )
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      retract_doc = Nokogiri.XML(post("distribution/streaming/retract", args))
      job_url = retract_doc.search("url").first.text
    end
    
    def delete_hls_track( media_package, track_id )
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      retract_doc = Nokogiri.XML(post("distribution/hls/retract", args))
      job_url = retract_doc.search("url").first.text
    end
  end
end

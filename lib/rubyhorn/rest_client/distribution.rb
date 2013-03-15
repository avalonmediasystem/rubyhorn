module Rubyhorn::RestClient
  module Distribution
     
    # Returns the url to the job xml, which can be used to query job's status
    def delete_track( workflow_id, track_id )
      media_package = Rubyhorn.client.get_media_package(workflow_id)
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      retract_doc = Nokogiri.XML(post("distribution/streaming/retract", args))
      job_url = retract_doc.search("url").first.text
    end
    
    def delete_hls_track( workflow_id, track_id )
      media_package = Rubyhorn.client.get_media_package(workflow_id)
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      retract_doc = Nokogiri.XML(post("distribution/hls/retract", args))
      job_url = retract_doc.search("url").first.text
    end
    # def delete_workflow_tracks(workflow_id)
    #   media_package = Rubyhorn.client.get_media_package(workflow_id)
    #   tracks = media_package.xpath('//track').map{|node| node.get_attribute('id')}

    #   tracks.each do |track|
    #     Rubyhorn.client.delete_track(media_package.to_s, track)
    #   end
    # end
  end
end

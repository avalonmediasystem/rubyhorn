module Rubyhorn::RestClient
  module Distribution

    def delete_track( workflow_id, track_id )
      media_package = Rubyhorn.client.get_media_package(workflow_id)
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      post("distribution/streaming/retract", args)
    end
    
    def delete_hls_track( workflow_id, track_id )
      media_package = Rubyhorn.client.get_media_package(workflow_id)
      args = { 
        :mediapackage => media_package,
        :elementId => track_id
      }

      post("distribution/hls/retract", args)
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

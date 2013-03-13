module Rubyhorn::RestClient
  module HLSDistribution

    def delete_track( media_package, track )
      args = { 
        :mediapackage => media_package,
        :elementId => track
      }

      post("distribution/streaming/retract", args)
    end
    
    # example usage of delete_track
    # def delete_workflow_tracks(workflow_id)
    #   media_package = Rubyhorn.client.get_media_package(workflow_id)
    #   tracks = media_package.xpath('//track').map{|node| node.get_attribute('id')}

    #   tracks.each do |track|
    #     Rubyhorn.client.delete_track(media_package.to_s, track)
    #   end
    # end
  end
end
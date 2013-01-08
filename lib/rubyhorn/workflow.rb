require "om"

module Rubyhorn
  class Workflow
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path=>"workflow", :xmlns=>"http://workflow.opencastproject.org", "xmlns:ns3"=>"http://mediapackage.opencastproject.org")
      t.id(:path => {:attribute=>"id"})
      t.state(:path => {:attribute=>"state"})
      t.template
      t.title
      t.description
      t.mediapackage(:namespace_prefix=>"ns3") {
        t.id(:path => {:attribute=>"id"})
        t.title(:namespace_prefix=>"ns3")
        t.media(:namespace_prefix=>"ns3") {
          t.track(:namespace_prefix=>"ns3") {
            t.type(:path => {:attribute => "type"})
	    t.mimetype(:namespace_prefix=>"ns3")
            t.url(:namespace_prefix=>"ns3")
            t.duration(:namespace_prefix=>"ns3")
            t.tags(:namespace_prefix=>"ns3"){
              t.tag(:namespace_prefix=>"ns3")
            }
          }
        }

	t.streaming_tracks(ref: [:mediapackage, :media, :track], 
			attributes: {type: "presenter/delivery"})
	t.source_tracks(ref: [:mediapackage, :media, :track],
			attributes: {type: "presenter/source"})
	t.thumbnail_track(ref: [:mediapackage, :media, :track],
			  attributes: {type: "presenter/search+preview"})
	t.poster_track(ref: [:mediapackage, :media, :track],
		       attributes: {type: "presenter/player+preview"})

        t.metadata(:namespace_prefix=>"ns3") {
          t.catalog(:namespace_prefix=>"ns3") {
            t.mimetype(:namespace_prefix=>"ns3")
            t.url(:namespace_prefix=>"ns3")
          }
        }
        t.attachments(:namespace_prefix=>"ns3"){
          t.attachment(:namespace_prefix=>"ns3"){
            t.type(:path => {:attribute => "type"})
            t.url(:namespace_prefix=>"ns3")
          }
        }
      }
      t.operations {
        t.operation {
          t.operationState(:path => {:attribute=>"state"})
          t.configurations {
            t.configuration
          }
        }
      }
      t.configurations
      t.errors
      
      t.feedpreview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/feed+preview"]/ns3:url')
      t.searchpreview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/search+preview"]/ns3:url')
      t.playerpreview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/player+preview"]/ns3:url')
      t.streamingmimetype(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and tags/tag = "streaming"]/ns3:mimetype')
      t.streamingurl(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and ns3:tags/ns3:tag = "streaming"]/ns3:url')
      t.streamingresolution(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and ns3:tags/ns3:tag = "streaming"]/ns3:video/ns3:resolution')
      t.httpmimetype(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and not(tags/tag = "streaming") and tags/tag = "engage"]/ns3:mimetype')
      t.httpurl(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and not(tags/tag = "streaming") and tags/tag = "engage"]/ns3:url')
    end

    # This XPath is meant to extract only the tracks which have a streaming
    # tag and are actually meant for delivery. It will then return a list of
    # track IDs that need to be processed.
    def self.streaming_derivatives 
      xpath = "#{terminology.xpath_for(:streaming_tracks)} and ns3:tags/tag = 'streaming']/@id"
      # DEBUG
      # See what the xPath query looks like
      puts "XPath query -> #{xpath}"  
      # END DEBUG
      ng_xml.xpath(xpath, ng_xml.root.namespace)    
    end
  end
end

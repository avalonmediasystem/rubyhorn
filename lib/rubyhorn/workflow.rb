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
	    t.checksum(namespace_prefix: 'ns3')
            t.tags(:namespace_prefix=>"ns3"){
              t.tag(:namespace_prefix=>"ns3")
            }
          }
        }

	t.streaming_tracks(ref: [:mediapackage, :media, :track], 
			attributes: {type: "presenter/delivery"})
	t.source_tracks(ref: [:mediapackage, :media, :track],
			attributes: {type: "presenter/source"})
	t.thumbnail_images(ref: [:mediapackage, :attachments, :attachment],
			  attributes: {type: "presenter/search+preview"})
	t.poster_images(ref: [:mediapackage, :attachments, :attachment],
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
          t.operation_state(:path => {:attribute=>"state"})
          t.configurations {
            t.configuration
          }
        }
      }
      t.configurations
      t.errors
      
      t.feed_preview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/feed+preview"]/ns3:url')
      t.search_preview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/search+preview"]/ns3:url')
      t.player_preview(:path=>'workflow/ns3:mediapackage/ns3:attachments/ns3:attachment[@type="presenter/player+preview"]/ns3:url')
      t.streaming_mime_type(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and tags/tag = "streaming"]/ns3:mimetype')
      t.streaming_url(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and ns3:tags/ns3:tag = "streaming"]/ns3:url')
      t.streaming_resolution(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and ns3:tags/ns3:tag = "streaming"]/ns3:video/ns3:resolution')
      t.http_mime_type(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and not(tags/tag = "streaming") and tags/tag = "engage"]/ns3:mimetype')
      t.http_url(:path=>'workflow/ns3:mediapackage/ns3:media/ns3:track[@type="presenter/delivery" and not(tags/tag = "streaming") and tags/tag = "engage"]/ns3:url')
    end

    # This XPath is meant to extract only the tracks which have a streaming
    # tag and are actually meant for delivery. It will then return a list of
    # track IDs that need to be processed.
    def streaming_derivatives 
      xpath = "#{terminology.xpath_for(:streaming_tracks)} and ns3:tags/tag = 'streaming']/@id"
      # DEBUG
      # See what the xPath query looks like
      puts "XPath query -> #{xpath}"  
      # END DEBUG
      ng_xml.xpath(xpath, ng_xml.root.namespace)    
    end

    # Given a list of symbols from the terminology it will return the
    # nodeset
    # 
    # For example
    # workflow.nodeset_for(:source_tracks)
    #
    # should return a list of the files used to generate derivatives
    def nodeset_for(symbols)
       ng_xml.xpath(terminology.xpath_for(symbols))
    end
  end
end

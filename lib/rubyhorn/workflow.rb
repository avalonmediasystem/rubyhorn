require "om"

module Rubyhorn
  class Workflow
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path=>"workflow", :xmlns=>'', "xmlns:ns2"=>"http://workflow.opencastproject.org", :namespace_prefix=>"ns2")
      t.id(:path => {:attribute=>"id"}, :namespace_prefix=>nil)
      t.state(:path => {:attribute=>"state"}, :namespace_prefix=>nil)
      t.template(:namespace_prefix=>nil)
      t.title(:namespace_prefix=>nil)
      t.description(:namespace_prefix=>nil)
      t.mediapackage(:namespace_prefix=>nil) {
        t.id(:path => {:attribute=>"id"}, :namespace_prefix=>nil)
        t.title(:namespace_prefix=>nil)
        t.media(:namespace_prefix=>nil) {
          t.track(:namespace_prefix=>nil) {
            t.type(:path => {:attribute => "type"}, :namespace_prefix=>nil)
						t.mimetype(:path => {:attribute=>"mimetype"}, :namespace_prefix=>nil)
            t.url(:namespace_prefix=>nil)
            t.duration(:namespace_prefix=>nil)
          }
        }
        t.metadata(:namespace_prefix=>nil) {
          t.catalog(:namespace_prefix=>nil) {
            t.mimetype(:namespace_prefix=>nil)
            t.url(:namespace_prefix=>nil)
          }
        }
        t.attachments(:namespace_prefix=>nil){
          t.attachment(:namespace_prefix=>nil){
            t.type(:path => {:attribute => "type"}, :namespace_prefix=>nil)
            t.url(:namespace_prefix=>nil)
          }
        }
      }
      t.operations(:namespace_prefix=>nil) {
        t.operation(:namespace_prefix=>nil) {
          t.operationState(:path => {:attribute=>"state"}, :namespace_prefix=>nil)
          t.configurations(:namespace_prefix=>nil) {
            t.configuration(:namespace_prefix=>nil)
          }
        }
      }
      t.configurations(:namespace_prefix=>nil)
      t.errors(:namespace_prefix=>nil)
      
      t.feedpreview(:path=>'workflow/mediapackage/attachments/attachment[@type="presenter/feed+preview"]/url', :namespace_prefix=>"ns2")
      t.searchpreview(:path=>'workflow/mediapackage/attachments/attachment[@type="presenter/search+preview"]/url', :namespace_prefix=>"ns2")
      t.playerpreview(:path=>'workflow/mediapackage/attachments/attachment[@type="presenter/player+preview"]/url', :namespace_prefix=>"ns2")
    end
  end
end

require "om"

module Rubyhorn
  class Workflow
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path=>"workflow", :xmlns=>"http://workflow.opencastproject.org", :namespace_prefix=>"ns2")
      t.template(:namespace_prefix=>nil)
      t.title(:namespace_prefix=>nil)
      t.description(:namespace_prefix=>nil)
      t.mediapackage(:namespace_prefix=>nil) {
        t.title(:namespace_prefix=>nil)
        t.media(:namespace_prefix=>nil) {
          t.track(:namespace_prefix=>nil) {
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
        t.attachments(:namespace_prefix=>nil)
      }
      t.operations(:namespace_prefix=>nil) {
        t.operation(:namespace_prefix=>nil) {
          t.configurations(:namespace_prefix=>nil) {
            t.configuration(:namespace_prefix=>nil)
          }
        }
      }
      t.configurations(:namespace_prefix=>nil)
      t.errors(:namespace_prefix=>nil)
    end
  end
end

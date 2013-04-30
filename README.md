rubyhorn
========

A Opencast Matterhorn REST API client ruby library

Installation
========

gem install rubyhorn

Examples
=======

  Rubyhorn.init
  workflow_doc = Rubyhorn.client.addMediaPackageWithUrl()
  workflow_id = workflow_doc.workflow.id.first
  workflow_doc = Rubyhorn.client.instance_xml(workflow_id)
  workflow_doc.title.first
  workflow_doc.streaming_url
  Rubyhorn.client.stop(workflow_id)
  

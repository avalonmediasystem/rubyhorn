require 'net/http/digest_auth'
require 'net/http/post/multipart'
require "mime/types"

module Rubyhorn::RestClient
  module Common
    attr_reader :http
    attr_reader :cookie

    def login
	uri = URI.parse(config[:uri] + "welcome.html")
	uri.user = config[:user]
	uri.password = config[:password]
	@http = Net::HTTP.new uri.host, uri.port
        req = Net::HTTP::Head.new uri.request_uri
        req['X-REQUESTED-AUTH'] = 'Digest'
	res = @http.request req
        
        digest_auth = Net::HTTP::DigestAuth.new
        auth = digest_auth.auth_header uri, res['www-authenticate'], 'HEAD' 
        req = Net::HTTP::Head.new uri.request_uri
        req.add_field 'Authorization', auth
        res = @http.request req
	@cookie = res['set-cookie']
    end

    def get url, args = {}
      query = args.to_a.each { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
      url = config[:uri] + url
      if !query.empty?
        url << "?" << query
      end
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = @cookie
      response = @http.request(request)
      return response.body    
    end

    def post uri, args = {}
      #TODO implement me!
    end

    def multipart_post url, file, args = {}
      file_name = File.basename file.path
      reqparams = args.to_a
      mime_type = MIME::Types.of(file_name)
      reqparams << ["BODY", UploadIO.new(file, mime_type, file_name)]
      url = config[:uri] + url
      uri = URI.parse(url)

      req = Net::HTTP::Post::Multipart.new uri.path, reqparams
      req['Cookie'] = @cookie
      res = @http.request(req)
      return res.body
    end
  end
end

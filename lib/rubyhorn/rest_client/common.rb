require 'net/http/digest_auth'
require 'net/http/post/multipart'
require "mime/types"

module Rubyhorn::RestClient
  module Common
    attr_reader :http
    attr_reader :cookie

    def connect
	uri = URI.parse(config[:uri])
	@http = Net::HTTP.new uri.host, uri.port
	@http.set_debug_output $stderr if !config[:debug].nil? and config[:debug].downcase == 'true'	
	login
    end

    def login url = "welcome.html"
	uri = URI.parse(config[:uri] + url)
        req = Net::HTTP::Head.new uri.request_uri
	res = execute_request(uri, req)
	@cookie = res['set-cookie']
    end

    def execute_request uri, req
	uri.user = config[:user]
	uri.password = config[:password]
        head = Net::HTTP::Head.new uri.request_uri	
        head['X-REQUESTED-AUTH'] = 'Digest'
	res = @http.request head
	
#	if res.code.to_i != 200
          digest_auth = Net::HTTP::DigestAuth.new
          auth = digest_auth.auth_header uri, res['www-authenticate'], req.method 
          req.add_field 'Authorization', auth
          res = @http.request req
#        end
#	res
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
      response = execute_request(uri, request)
      return response.body    
    end

    def post uri, args = {}
      #TODO implement me!
    end

    def multipart_post url, file, args = {}
      if args.has_key? "filename"
        filename = args["filename"]
      else
        filename = File.basename file.path
      end
      reqparams = args.to_a
      mime_type = MIME::Types.of(filename)
      reqparams << ["BODY", UploadIO.new(file, mime_type, filename)]
      url = config[:uri] + url
      uri = URI.parse(url)

      req = Net::HTTP::Post::Multipart.new uri.path, reqparams
      req['Cookie'] = @cookie
      res = execute_request(uri, req)
      return res.body
    end
  end
end

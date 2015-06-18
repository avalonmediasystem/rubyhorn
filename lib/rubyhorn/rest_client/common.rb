require 'rest-client'
require 'net/http/digest_auth'
require 'uri'

module Rubyhorn::RestClient
  module Common

    def connect
      @client = RestClient::Resource.new(config[:url], headers: {'X-REQUESTED-AUTH'=>'Digest'})
      login
    end

    def login url = "welcome.html"
      get url
    end

    def auth_header(url, method)
      auth = nil
      urii = URI.parse(config[:url]).merge(url)
      urii.user = nil
      urii.password = nil
      begin
        RestClient.head(urii.to_s, 'X-REQUESTED-AUTH'=>'Digest') { |resp, req, result|
          if result['www-authenticate'] =~ /Digest realm=/
            uri = URI.parse(req.url)
            uri.user = config[:user]
            uri.password = config[:password]
            auth = Net::HTTP::DigestAuth.new.auth_header uri, result['www-authenticate'], method.upcase
          end
        }
      end
      { 'Authorization' => auth }
    end

    def parse_response(resp, req, result)
      code_as_int = resp.code.to_i
      if code_as_int == 404
        raise Rubyhorn::RestClient::Exceptions::HTTPNotFound.new
      elsif code_as_int.between?(500,599)
        raise Rubyhorn::RestClient::Exceptions::ServerError.new(code_as_int)
      end
      resp
    end

    def get url, args = {}
      url = url.slice(1..-1) if url.start_with? '/'
      queryparams = []
      args.each { |key, value| queryparams << "#{key}=#{CGI.escape(value.to_s)}" }
      query = queryparams.join("&")
      if !query.empty?
        url << "?" << query
      end
      @client[url].get(auth_header(url,'get')) { |*args| parse_response(*args) }
    end

    def post url, args = {}
      url = url.slice(1..-1) if url.start_with? '/'
      @client[url].post(args, auth_header(url,'post')) { |*args| parse_response(*args) }
    end

    def delete( url, args )
      url = url.slice(1..-1) if url.start_with? '/'
      @client[url].delete(auth_header(url,'delete')) { |*args| parse_response(*args) }
    end
  end
end

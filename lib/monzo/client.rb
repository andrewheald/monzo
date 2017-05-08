require "net/https"
require "uri"

module Monzo
  class Client

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def get(path, options = {})
      uri = build_uri(path, options)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request["Authorization"] = "Bearer #{access_token}"

      response = http.request(request)
      puts response.body
      response
    end

    def post(path, data, options = {})
      uri = build_uri(path, options = {})

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Authorization"] = "Bearer #{access_token}"

      request.set_form_data(data)

      response = http.request(request)
      puts response.body
      response
    end

    def delete(path, options = {})
      uri = build_uri(path, options = {})

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Delete.new(uri.request_uri)
      request["Authorization"] = "Bearer #{access_token}"

      response = http.request(request)
      puts response.body
      response
    end

    private

    def build_uri(path, options)
      uri = URI.join(host, path)
      uri.query = build_query(options)
      uri
    end

    def build_query(options)
      URI.encode_www_form(options)
    end

    def host
      "https://api.monzo.com/"
    end

  end
end

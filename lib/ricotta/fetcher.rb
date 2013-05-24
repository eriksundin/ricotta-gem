require 'faraday'
require 'faraday_middleware'

module Ricotta::Fetcher
    class Client
      
    def initialize(url)
      @connection = Faraday.new(:url => url) do |builder|
        builder.use FaradayMiddleware::FollowRedirects
        builder.adapter :net_http
      end
    end
    def fetch(project, branch, language, template, subset)
      path = "/proj/#{project}/branch/#{branch}/lang/#{language}/templ/#{template}/"
      path.concat("subset/#{subset}/") if subset
      
      @connection.get(path).on_complete do |env|
        yield env[:status], env[:body] if block_given?
      end
    end
  end
end


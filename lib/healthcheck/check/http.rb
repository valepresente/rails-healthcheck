require 'net/http'
require 'json'

module Healthcheck
  class Check::Http
    def self.check(dependency)
      begin
        body = JSON.parse Net::HTTP.get(URI("#{dependency[:url]}/healthcheck"))
        dependency[:dependencies] = body["dependencies"] || []
        body["version"] == dependency[:version] && body["name"] == dependency[:name]
      rescue
        false
      end
    end

  end

end

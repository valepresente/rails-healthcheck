require 'net/http'
require 'json'

module Healthcheck
  class Check::Http
    def self.check(dependency)
      dependency[:errors] ||= {}
      begin
        body = JSON.parse Net::HTTP.get(URI("#{dependency[:url]}/healthcheck"))
        dependency[:dependencies] = body["dependencies"] || []
        checked = true
        if ::Healthcheck::Check.check_version(body["version"], dependency[:version])
          dependency[:errors][:version] ||= []
          dependency[:errors][:version] << "Version #{body[:version]} not satisfies #{dependency[:version]}";
          checked = false
        end
        if body["name"] != dependency[:name]
          dependency[:errors][:name] ||= []
          dependency[:errors][:name] << "name #{body["name"]} is not equals to #{dependency[:name]}";
          checked = false
        end
        checked
      rescue => e
        dependency[:errors][:connection] ||= []
        dependency[:errors][:connection] << "#{e}";
        false
      end
    end

  end

end

require 'semverse/constraint'
require 'semverse/version'

module Healthcheck
  module Check
    def self.check_version(current, expected)
      Semverse::Constraint.new(expected).satisfies Semverse::Version.new(current)
    end
  end
end

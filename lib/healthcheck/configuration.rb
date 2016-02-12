module Healthcheck
  def self.Configuration=(config)
    @config = config
  end

  def self.Configuration
    @config
  end

  class Configure
    include Dependency
    attr_accessor :app, :name, :version

    def initialize(*args)
      Healthcheck.Configuration = self
      yield self if block_given?
    end

  end

end

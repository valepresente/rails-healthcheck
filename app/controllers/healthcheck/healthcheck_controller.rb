require 'healthcheck/graph'
module Healthcheck
  class HealthcheckController < ApplicationController
    skip_filter *_process_action_callbacks.map(&:filter)

    def index
      status = {
        name: Healthcheck.Configuration.name,
        version: Healthcheck.Configuration.version,
      }
      if params[:check_dependencies] == 'true'
        status[:dependencies] = Healthcheck.Configuration.dependencies
        status[:status] = status[:dependencies].reduce(true){ |status, d| status && d[:status] }
      else
        status[:dependencies] = Healthcheck.Configuration.dependencies_without_check
      end
      render json: status
    end

    def graph
      file = ::Healthcheck::Graph.generate_file
      render inline: file.read
    end
  end
end

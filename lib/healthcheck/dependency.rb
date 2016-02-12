module Healthcheck
  module Dependency

    def add_dependency(dependency)
      @dependencies ||= []
      @dependencies << dependency
    end

    def dependencies_without_check
      @dependencies ||= []
    end

    def dependencies
      result = []
      dependencies_without_check.each do |_dependency|
        dependency = _dependency.clone.with_indifferent_access
        if dependency[:type] == :http
          get_http_data(dependency)
        end
        result << dependency
      end
      result
    end

    private

    def get_http_data(dependency)
      dependency[:status] = ::Healthcheck::Check::Http.check(dependency)
      (dependency[:dependencies]||[]).each do |_dependency|
        get_http_data(_dependency.with_indifferent_access)
      end
    end

  end
end

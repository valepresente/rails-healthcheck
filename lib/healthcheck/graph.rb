require 'graphviz'

module Healthcheck
  class Graph

    def self.generate
      # Create a new graph
      graph = GraphViz.new( :G, :type => :digraph )
      # dependencies = Healthcheck.Configuration.dependencies

      # app = g.add_nodes(Healthcheck.Configuration.name)
      add_node(graph, {
          name: Healthcheck.Configuration.name,
          version: Healthcheck.Configuration.version,
          dependencies: Healthcheck.Configuration.dependencies,
          status: true
      }.with_indifferent_access)

      # if dependency[:status] != true
      #   app_dep[:style] = 'filled'
      #   app_dep[:fillcolor] = 'red'
      #   app_dep[:fontcolor] = 'white'
      # end
      # if dependencies.reduce{|status, d| status && d[:status] } != true
      #   app[:style] = 'filled'
      #   app[:fillcolor] = 'yellow'
      # end
      graph
    end

    def self.generate_file
      file = Tempfile.new('foo')
      self.generate.output "svg" => file.path
      file
    end

    private

    def self.add_node(graph, app)
      graph.get_node(app[:name]) || begin
        node = graph.add_nodes(app[:name])
        dependencies = app[:dependencies]||[]
        dependencies.each do |dependency|
          graph.add_edges(node, self.add_node(graph, dependency))
        end
        dependencies_ok = dependencies.reduce{|status, d| status && d[:status] }
        if app[:status] != true
          node[:style] = 'filled'
          node[:fillcolor] = 'red'
          node[:fontcolor] = 'white'
        elsif dependencies.size>0 && dependencies_ok != true
          node[:style] = 'filled'
          node[:fillcolor] = 'yellow'
        end
        node
      end
    end
  end
end

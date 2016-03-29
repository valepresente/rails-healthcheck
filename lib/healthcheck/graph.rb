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
      node = graph.get_node(app[:name]) || graph.add_nodes(app[:name])
      dependencies = app[:dependencies]||[]
      dependencies.each do |dependency|
        node_dependency = self.add_node(graph, dependency)
        if graph.each_edge.select{|edge| edge.node_one==node.id && edge.node_two==node_dependency.id}.size == 0
          graph.add_edges(node, node_dependency)
        end
      end
      dependencies_ok = dependencies.reduce(true){|status, d| status && d[:status] }
      if dependencies.size==0 && node[:fontcolor].nil?
        if app[:status] == true
          node[:style] = 'filled'
          node[:fillcolor] = 'green'
          node[:fontcolor] = 'white'
        elsif app[:status] == false
          node[:style] = 'filled'
          node[:fillcolor] = 'red'
          node[:fontcolor] = 'white'
        end
      elsif dependencies.size>0 && dependencies_ok != true
        node[:style] = 'filled'
        node[:fillcolor] = 'yellow'
        node[:fontcolor] = 'black'
      elsif dependencies.size>0 && dependencies_ok == true
        node[:style] = 'filled'
        node[:fillcolor] = 'green'
        node[:fontcolor] = 'white'
      end
      node
    end
  end
end

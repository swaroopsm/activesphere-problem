require_relative './commons'

module ActiveSphere
  class Server

    include Commons

    attr_accessor :machine, :name, :nodes, :prev, :next

    def initialize(name)
      @name = name
      @machine = generate_hash(@name)
      @nodes = {}
    end

    def nodes=(node)
      @nodes[node.key] = node.value
    end

    def migrate_nodes
      self.next.nodes.merge!(self.nodes)
      self.next.prev = self.prev
    end

    def destroy
      servers = ActiveSphere::Engine.servers
      self.migrate_nodes
      ActiveSphere::Engine.servers = servers - [self]
    end

  end
end

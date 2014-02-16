require_relative './commons'

module ActiveSphere
  class Server

    include Commons

    attr_accessor :machine, :name, :nodes, :prev, :next

    def initialize(name, engine)
      @engine = engine
      @name = name
      @machine = generate_hash(@name)
      @nodes = {}
    end

    def nodes=(node)
      @nodes[node.key] = node.value
    end

    def remap
      current_index = @engine.servers.index(self)

      unless self.first?
        self.prev = @engine.servers[current_index - 1] 
      else
        self.prev = @engine.servers.last
      end

      if self.last?
        self.next = @engine.servers.first
      else
        self.next = @engine.servers[current_index + 1]
      end

    end

    def first?
      self.equal? @engine.servers.first
    end

    def last?
      self.equal? @engine.servers.last

    end

    def migrate_nodes
      self.next.nodes.merge!(self.nodes)
      self.next.prev = self.prev if self.prev
    end

    def remove(index)
      self.migrate_nodes

      @engine.servers.delete_at(index)
    end

  end
end

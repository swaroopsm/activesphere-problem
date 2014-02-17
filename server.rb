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

      # Link next and prev for each node
      @engine.servers.each_with_index do |server, index|
        server.prev = @engine.servers.last if server.first? and server != @engine.servers.last
        if server.last?
          server.next = @engine.servers.first if server != @engine.servers.first
          server.prev = @engine.servers[index-1] if server != @engine.servers.first
        else
          server.prev = @engine.servers[index-1] unless server.first?
          server.next = @engine.servers[index+1]
        end
      end

      # If server is added at the first position in the ring
      if self.first? and @engine.servers.size > 1
        self.nodes.merge! self.next.nodes.select{ |k, v| k <= self.next.machine }
        self.next.nodes.reject!{ |k, v| k <= self.next.machine }
      end

      # If server is added at the last in the ring
      if self.last? and !self.first? and self.next
        self.nodes.merge! self.next.nodes.select{ |k, v| k >= self.machine }
        self.next.nodes.reject!{ |k, v| k >= self.machine }
      end

      # If server is added between a position that is in-between two other servers in the ring
      if !self.first? and !self.last?
        self.nodes.merge! self.prev.nodes.select{ |k, v| k >= self.machine }
        self.prev.nodes.reject!{ |k, v| k >= self.machine }

        self.nodes.merge! self.next.nodes.select{ |k, v| k <= self.machine }
        self.next.nodes.reject!{ |k, v| k <= self.machine }
      end
    end

    # Determine if first server in the ring
    def first?
      self.equal? @engine.servers.first
    end

    # Determine if last server in the ring
    def last?
      self.equal? @engine.servers.last
    end

    # Remove a server from the ring
    def remove(index, engine)
      servers = engine.servers.reject{ |server| server == self  }

      # TODO: Don't know if this is right?
      self.nodes.each do |k, v|
        server = engine.find_server(k, {:ignore => self})
        p server.name
        server.nodes.merge!({k => v})
      end

      self.next.prev = self.prev
      self.prev.next = self.next

      @engine.servers.delete_at(index)
    end

  end
end

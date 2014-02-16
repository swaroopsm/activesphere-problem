require_relative './commons'

module ActiveSphere
	class Engine

	  include Commons

		@@data = {}

    attr_accessor :name, :memory, :servers

    def initialize
      @servers = []
    end

    def memory=(memory)
      @memory = memory.to_f * 1024 * 1024
    end

    def servers=(server)
      @servers << server
      @servers.sort_by!{ |server| server.machine }

      server.remap
    end

    # Find Server by name
    def find(name)
      self.servers.each_with_index{ |server, index| return { :server => server, :index => index } if server.name == name }

      nil
    end

		# Free data less than memory, uses LRU
		def self.free
			key_to_remove = @@data.sort_by{ |k,v| v.value[:counter] }.flatten[0]
			@@data.delete key_to_remove
		end

		def self.size
			ObjectSpace.memsize_of(@@data)
		end

		# Check if exceeded specified memory
		def self.overflow?
			 Engine.size > @@memory
		end

    def self.remap
      @@servers.each_with_index do |server, index|
        if index != @@servers.size
          server.next = @@servers[index+1] 
        else
          server.next = @@servers[0]
        end

        server.prev = @@servers[index-1] if index > 0
      end
    end

    def find_server(key)
      self.servers.each do |server|
        if key > server.machine
          return server
        end
      end

      self.servers.first
    end

	end
end

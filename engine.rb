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

    # TODO
    # Find Memory Size
		def size

		end

    # TODO
		# Check if exceeded specified memory
		def overflow?

		end

    def find_server(key, options={})
      servers = []
      all_servers = options[:ignore] ? self.servers.reject{ |server| server == options[:ignore] } : self.servers
      all_servers.each do |server|
        if key >= server.machine
          servers << server
        end
      end

      servers.size > 0 ? servers.sort_by{ |server| server.machine }.last : all_servers.first
    end

	end
end

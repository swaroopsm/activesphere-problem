module ActiveSphere
	class Engine

		@@data = {}

		def self.memory=(memory)
			@@memory = memory.to_f * 1024 * 1024
		end

		def self.memory
			@@memory
		end

		def self.servers=(servers)
			@@servers = servers
		end

		def self.servers
			@@servers
		end

		def self.data
			@@data
		end

		# Free data less than memory, uses LRU
		def self.free
			key_to_remove = @@data.sort_by{ |k,v| v[:counter] }.flatten[0]
			@@data.delete key_to_remove
		end

		def self.size
			ObjectSpace.memsize_of(@@data)
		end

		# Check if exceeded specified memory
		def self.overflow?
			 Engine.size > @@memory
		end

		# Create hash of the key
		def generate_hash(key)
			Digest::MD5.hexdigest(key)
		end

	end
end

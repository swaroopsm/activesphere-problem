module ActiveSphere
	module Command
		class Set < Base

			attr_accessor :key, :value

			def initialize(key, value)
				@key = generate_hash(key)
				@value = { :value => value, :counter => Time.now.to_i }
				self.server = find_server(@key)
				self.server.nodes = self
			end

			def process
				if Engine.overflow?
					Engine.free
				end
				Engine.data[@key] = self
			end

		end
	end
end

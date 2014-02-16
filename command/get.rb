module ActiveSphere
	module Command
		class Get < Base

			attr_accessor :key

			def initialize(key)
				@key = generate_hash(key)

			end

			def process(engine)
			  server = engine.find_server(@key)
			  server.nodes
			  # server.nodes[@key][:value]
			end

		end
	end
end

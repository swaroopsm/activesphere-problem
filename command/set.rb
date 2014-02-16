module ActiveSphere
	module Command
		class Set < Base

			attr_accessor :key, :value

			def initialize(key, value)
				@key = generate_hash(key)
				@value = { :value => value, :counter => Time.now.to_i }
			end

			def process(engine)
				self.server = engine.find_server(@key)
				self.server.nodes = self

				# if @engine.overflow?
				# 	@engine.free
				# end
			end

		end
	end
end

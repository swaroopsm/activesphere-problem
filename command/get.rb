module ActiveSphere
	module Command
		class Get < Base

			attr_accessor :key

			def initialize(key)
				@key = generate_hash(key)
			end

			def process
				if @@data.size > 0
					if Engine.data["#{key}"]
						Engine.data["#{key}"][:counter] = Time.now.to_i
						Engine.data["#{key}"][:value] 
					end
				end
			end

		end
	end
end

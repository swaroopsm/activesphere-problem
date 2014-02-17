module ActiveSphere
	module Command
		class Get < Base

			attr_accessor :key

			def initialize(key)
				@key = generate_hash(key)

			end

			def process(engine)
			  server = engine.find_server(@key)
			  begin
			    server.nodes[@key][:value]
        rescue Exception => e
          print "\nNot Found \n".colorize(:default).bold
        end
			end

		end
	end
end

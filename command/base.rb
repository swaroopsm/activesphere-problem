module ActiveSphere
	module Command
		class Base < ActiveSphere::Engine

			attr_accessor :input, :command, :server

			COMMANDS = %w( set get all flush )
			
			def initialize(input)
				@input = input
				@command = parse_command
			end

			def process
				if valid?
					case @command
					when COMMANDS[0]
						Set.new(@input[1], @input[2]).process
					when COMMANDS[1]
						print Get.new(@input[1]).process
						print "\n"
					when COMMANDS[2]
						print Engine.data
						print "\n"
					when COMMANDS[3]
						flush
						print "\n"
					end
				end
			end

			def valid?
				COMMANDS.include? @command
			end

			def flush
				Engine.data.clear
			end

			private
			def parse_command
				@input = @input.split(" ")
				@input[0].downcase
			end

		end
	end
end

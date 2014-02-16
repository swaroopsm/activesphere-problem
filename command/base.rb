require_relative '../commons'

module ActiveSphere
	module Command
		class Base

		  include Commons

			attr_accessor :input, :command, :server
			attr_reader   :engine

			COMMANDS = %w( set get all flush help add-server rm-server servers )
			
			def initialize(input, engine)
			  @engine = engine
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
					when COMMANDS[4]
					  help = Help.new
					  help.all
					when COMMANDS[5]
					  server = Server.new(@input[1], @engine)
					  @engine.servers = server
					when COMMANDS[6]
					  server = @engine.find(@input[1])

					  server[:server].remove(server[:index]) if server
					when COMMANDS[7]
					  @engine.servers.each{ |server| print "- #{server.name}\n".colorize(:default).bold }
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

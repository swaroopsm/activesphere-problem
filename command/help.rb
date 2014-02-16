module ActiveSphere
	module Command
		class Help < Base

			def initialize
			  @data = YAML.load_file(File.expand_path('../../help.yml', __FILE__))
			end

      def all
        @data['command'].each do |command, usage|
          print formatter(command, usage)
        end
      end

      private
      def formatter(command, usage)
        formatted = "\n - #{command}".colorize(:default).bold
        formatted += "\n   #{usage['description']} \n"
        formatted += "\n   USAGE:".colorize(:default).bold
        formatted += "\n   #{usage['syntax']}\n"

        formatted
      end

		end
	end
end

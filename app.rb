#!/usr/bin/env ruby

require "digest"
require "objspace"

require_relative "engine"
require_relative "command/base"
require_relative "command/set"
require_relative "command/get"

ALLOWED_FLAGS = %w( -m -vv )
arguments = ARGV.each_slice(2).to_a
arguments.each{ |a| raise "Invalid Flag" unless ALLOWED_FLAGS.include? a[0] }
hashed = {}
arguments.each{ |a| hashed[a[0]] = a[1] }

ActiveSphere::Engine.memory = hashed["-m"]

print "Type :q to quit\n"
while true
	input = $stdin.gets.chomp

	(input == ":q") ? exit : ActiveSphere::Command::Base.new(input).process
end

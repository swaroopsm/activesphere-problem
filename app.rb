#!/usr/bin/env ruby

require "digest"
require "objspace"

require_relative "engine"
require_relative "command/base"
require_relative "command/set"
require_relative "command/get"
require_relative "server"
require_relative "commons"

ALLOWED_FLAGS = %w( -m -vv )
arguments = ARGV.each_slice(2).to_a
arguments.each{ |a| raise "Invalid Flag" unless ALLOWED_FLAGS.include? a[0] }
hashed = {}
arguments.each{ |a| hashed[a[0]] = a[1] }

ActiveSphere::Engine.memory = hashed["-m"]

# Insert x servers
servers = [ "192.168.1.1", "192.168.1.2" ]
ActiveSphere::Engine.servers = servers.map{ |s| ActiveSphere::Server.new(s) }.sort_by{ |s| s.machine }
ActiveSphere::Engine.remap

def get_input
  print "Type :q to quit\n"
  while true
    input = $stdin.gets.chomp

    (input == ":q") ? return : ActiveSphere::Command::Base.new(input).process
  end
end

get_input

server1 = ActiveSphere::Engine.servers.first
server1.destroy

get_input

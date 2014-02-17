#!/usr/bin/env ruby

require "digest"
require "objspace"
require "yaml"
require "colorize"
require "socket"

require_relative "engine"
require_relative "command/base"
require_relative "command/set"
require_relative "command/get"
require_relative "command/help"
require_relative "server"
require_relative "commons"

ALLOWED_FLAGS = %w( -m -vv )
arguments = ARGV.each_slice(2).to_a
arguments.each{ |a| raise "Invalid Flag" unless ALLOWED_FLAGS.include? a[0] }
hashed = {}
arguments.each{ |a| hashed[a[0]] = a[1] }

@falcon = ActiveSphere::Engine.new
@falcon.name = "Falcon"
@falcon.memory = hashed["-m"]

# Assume some initial server
ip_address = IPSocket.getaddress(Socket.gethostname)
server = ActiveSphere::Server.new(ip_address, @falcon)
print "\nConncting to #{ip_address} ... \n\n"
@falcon.servers = server

# ActiveSphere::Engine.remap

def get_input
  print "Type :q to quit\n"
  print "Type help for a list of commands\n\n"
  loop do
    input = $stdin.gets.chomp

    (input == ":q") ? return : ActiveSphere::Command::Base.new(input, @falcon).process
  end
end

get_input

# server1 = ActiveSphere::Engine.servers.first
# server1.destroy
# 
# get_input

require 'JSON'

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  
  List = SubCommand.new(
    'list', # Name of the sub command
    'List all host entries',
    options_obj
  ) { |options, args|
    host_file = Hosts.host_file
    host_entries = host_file.get_all_entries
    host_entries.each do |dest, hostnames|
      hostname_f = hostnames * ", "
      puts "#{dest} => #{hostname_f}"
    }
  }
  @List
end

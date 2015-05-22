require 'JSON'

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  
  List = SubCommand.new(
    'list', # Name of the sub command
    'List all host entries',
    options_obj,
    false
  ) { |options, args|
    hosts_file = HostsFile.new Hosts.hosts_file
    hosts_entries = hosts_file.get_all_entries
    
    longest_dest_name = 0

    hosts_entries.each do |dest, hostnames|
      if (dest.length > longest_dest_name)
        longest_dest_name = dest.length
      end
    end

    hosts_entries.each do |dest, hostnames|
      hostname_f = hostnames * ", "

      print "%-#{longest_dest_name}.#{longest_dest_name}s" % dest
      print " "
      puts "<= #{hostname_f}"
    end
  }
  @List
end

include Hosts::Lib::Core
include Hosts::Lib

module Hosts::Lib::Commands
  options_obj = Slop::Options.new suppress_errors: true
  options_obj.banner = "Usage: hosts add [dest] [hostname [hostname [...]]]"

  Add = SubCommand.new(
    'add', # Name of the sub command
    'Add a hosts entry. requires \'sudo\'',
    options_obj
  ) { |options, args|
    unless (args.length >= 2)
      puts options_obj.banner
      next
    end

    hosts_file = HostsFile.new Hosts.hosts_file

    hosts_file.add_entry(args[0], args[1])


    # Write changes to hosts file
    begin
      hosts_file.flush
      puts "Added entry: #{args[0]} => #{args[1]}"
    rescue Errno::EACCES
      puts "Permission error: 'hosts add' requires 'sudo'"
    end
  }
  @Add
end

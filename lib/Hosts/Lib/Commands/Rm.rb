include Hosts::Lib::Core

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  options_obj.banner = "Usage: hosts dest [alias]"

  Rm = SubCommand.new(
    'rm', # Name of the sub command
    "Remove entry. Removes all entries to a 'dest' if no alias is defined. Requires 'sudo'",
    options_obj
  ) { |options, args|
    # Must be right number of arguments
    unless (args.length > 0 && args.length <= 2)
      puts options_obj
      next
    end

    hosts_file = HostsFile.new Hosts.hosts_file

    if (args[1] != nil)
      # rm alias
      hosts_file.rm_alias(args[0], args[1])
    else
      # Remove all entries
      # to 'dest' if alias
      # is not defined
      hosts_file.rm_dest_entries(args[0])
    end

    # Write changes to hosts file
    hosts_file.flush()
  }
  @Rm
end

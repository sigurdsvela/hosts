include Hosts::Lib::Core
include Hosts::Lib

module Hosts::Lib::Commands
  options_obj = Slop::Options.new suppress_errors: true
  options_obj.banner = "Usage: hosts add [dest] [hostname [hostname [...]]]"

  Add = SubCommand.new(
    'add', # Name of the sub command
    'Add a hosts entry',
    options_obj
  ) { |options, args|
    unless (args.length >= 2)
      puts options_obj.banner
      next
    end
  }
  @Add
end

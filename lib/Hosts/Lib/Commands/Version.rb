include Hosts::Lib::Core

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  
  Version = SubCommand.new(
    'version', # Name of the sub command
    'Print the version',
    options_obj,
    false
  ) { |options, args|
    puts Hosts::VERSION
  }
  @Version
end

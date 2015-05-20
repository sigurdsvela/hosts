include Hosts::Lib::Core

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  
  Rm = SubCommand.new(
    'rm', # Name of the sub command
    'Print info for a template',
    options_obj
  ) { |options, args|
  }
  @Rm
end

include Hosts::Lib::Core

module Hosts::Lib::Commands
  options_obj = Slop::Options.new
  
  Flush = SubCommand.new(
    'flush', # Name of the sub command
    'Flush the DNS cache',
    options_obj,
    false
  ) { |options, args|
    `dscacheutil -flushcache; sudo killall -HUP mDNSResponder &> /dev/null`
    puts "Flushed DNS cache"
  }
  @Flush
end

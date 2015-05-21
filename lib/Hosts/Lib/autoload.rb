require 'slop'

module Hosts
  LIB_PATH = File.dirname(File.dirname(File.expand_path("../", __FILE__)))
end

module Hosts::Lib end

module Hosts::Lib::Core
  autoload :HostsFile, File.dirname(__FILE__) + "/Core/HostsFile.rb"
  autoload :SubCommand, File.dirname(__FILE__) + "/Core/SubCommand.rb"
end

module Hosts::Lib::Commands
  autoload :Add, File.dirname(__FILE__) + "/Commands/Add.rb"
  autoload :Flush, File.dirname(__FILE__) + "/Commands/Flush.rb"
  autoload :Rm, File.dirname(__FILE__) + "/Commands/Rm.rb"
  autoload :List, File.dirname(__FILE__) + "/Commands/List.rb"
  autoload :Version, File.dirname(__FILE__) + "/Commands/Version.rb"
  autoload :Help, File.dirname(__FILE__) + "/Commands/Help.rb"
end

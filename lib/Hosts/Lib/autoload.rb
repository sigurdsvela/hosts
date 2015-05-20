require 'slop'

module Hosts
  LIB_PATH = File.dirname(File.dirname(File.expand_path("../", __FILE__)))
end

module Hosts::Lib end

module Hosts::Lib::Core
  autoload :HostsFile, File.dirname(__FILE__) + "/Core/HostsFile.rb"
end

module Hosts::Lib::Commands
  autoload :Add, File.dirname(__FILE__) + "/Commands/Add.rb"
  autoload :Remove, File.dirname(__FILE__) + "/Commands/Remove.rb"
  autoload :List, File.dirname(__FILE__) + "/Commands/List.rb"
  autoload :Version, File.dirname(__FILE__) + "/Commands/Version.rb"
end

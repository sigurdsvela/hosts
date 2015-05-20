require_relative 'Hosts/Lib/autoload.rb'

module Hosts
  VERSION = "0.1.0"

  def self.main
    @sub_commands = {}
    @sub_commands['help'] = Hosts::Lib::Commands::Help
    @sub_commands['new']  = Hosts::Lib::Commands::New
    @sub_commands['config']  = Hosts::Lib::Commands::Config
    @sub_commands['version']  = Hosts::Lib::Commands::Version
    @sub_commands['template']  = Hosts::Lib::Commands::Template

    if ARGV[0] == nil
      Hosts::Lib::Commands::Help.run([]);
    elsif @sub_commands[ARGV[0]].nil?
      puts "'#{ARGV[0]}' is not a sub command. See 'hosts help'"
    else
      sub_cmd_obj = @sub_commands[ARGV[0].downcase]
      ARGV.shift; # Remove subcommand from ARGV, rest is options
      sub_cmd_obj.run(ARGV)
    end
  end

  def self.dir
    File.dirname(File.expand_path(__FILE__))
  end

  def self.hosts_file
    return "/etc/hosts"
  end

  #attr_reader :sub_commands
  def self.sub_commands
    return @sub_commands
  end
end
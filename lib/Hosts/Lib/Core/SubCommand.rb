module Hosts::Lib::Core
  class SubCommand
    attr_reader :name
    attr_reader :description
    attr_reader :options

    # If true, print help message on empty args
    attr_reader :assume_help

    def initialize(name, description, options, assume_help = true, &block)
      @name        = name
      @description = description
      @options     = options
      @block       = block
      @assume_help  = assume_help
    end

    def run(args)
      begin
        # If no option spesified, assume --help
        if (assume_help)
          fail Slop::UnknownOption.new "Unknown option --help", "--help" if (args.length == 0)
        end

        @options.parse(args); # Dryrun to check for argument errors
        @block.call(@options, args)
      rescue Slop::UnknownOption => e
        if (e.flag == '--help')
          print_help_message
        else
          puts "#{e.message}. Try 'hosts #{@name} help'"
        end
      end
    end

    def self.is_flag(str)
      return str.start_with?("--") || (str.start_with?("-") && str.length == 2)
    end

    def print_help_message
      puts 'hosts ' + @name
      if (@description != '')
        puts "\tDescription:"
        puts "\t" + @description
      end
      if @options.options.length > 0
        puts
        puts "\tArguments:"
        @options.each do |a|
          print "\t" + '%-16.16s' % (a.flags * ', ')
          print "\t"
          print a.desc + "\n"
        end
      end
      puts
    end
  end
end

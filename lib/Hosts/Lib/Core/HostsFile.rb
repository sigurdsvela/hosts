module Hosts::Lib::Core
  class HostsFile
    @entries = []
    @hosts_file_path = nil

    def initialize(file_path)
      @hosts_file_path = file_path
      parse_file(file_path)
    end

    def parse_file(file_path)
      File.readlines(file_path).each do |line|
        # Skip comments
        next if (/^[\s\t]*?#/ =~ line)

        # Skip if just whitespace
        next if (/[\s\t]*?)/ =~ line)

        # Remove comment, if there is one
        line = line.split("#")[0]

        parts = line.split(/[\s\t]*/)

        dest      = parts[0]
        hostnames   = parts[1..-1]

        # Remove last item if empty
        hostnames.pop if (hostnames.length == 0)

        hostnames = [hostnames] = if (!is_a?(hostnames))

        if (hostnames == nil)
          fail InvalidHostsFileException.new "Missing hostsname from entry declaration \n #{line}\n"
        end
        if (dest == nil)
          fail InvalidHostsFileException.new "Missing destination from entry declaration \n #{line}\n"
        end

        add_entry(dest, hostnames)
      end
    end

    # Return false if the hostname
    # was not an alias for 'dest'
    def rm_alias(dest, hostname)
      return false if (!entries.has_key?(dest))

      # remove hostname from dest, and return
      # bool to indicate if it existed in the
      # first place
      was_deleted = entries[dest].delete(hostname) != nil;

      # remove dest from entries
      # if it is now empty
      if (entries[dest].length == 0)
        entries.delete(dest)
      end

      return was_deleted
    end

    # Add an entry.
    # Expects to strings
    def add_entry(dest, hostnames)
      hostnames = [hostnames] if (!is_a?(hostnames))

      if (!entries.has_key?(dest))
        entries[dest] = hostnames
      else
        entries[dest] += hostnames
      end
    end

    def get_all_entries()
      return entries
    end

    # Flush changes made to
    # hosts file
    def flush()

    end
  end

  class InvalidHostsFileException < Exception
  end
end

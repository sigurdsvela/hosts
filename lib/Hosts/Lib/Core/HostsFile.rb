require 'JSON'
require 'etc'

module Hosts::Lib::Core
  class HostsFile
    @hosts_file_path = nil

    def initialize(file_path)
      @entries = {}
      @hosts_file_path = file_path
      parse_file(file_path)
    end

    def parse_file(file_path)
      newline_count = 0
      comment_count = 0

      File.readlines(file_path).each do |line|
        # Add comments to @entries, to preserve them
        if (/^[\s\t]*?#/ =~ line)
          # Add comment to entries, minus the newline
          @entries["__comment__#{comment_count}"] = { "comment" => line[0..-2] }
          comment_count += 1
          next
        end

        # Add empty lines to @entries, to preserve them
        if (/^[\s\t]*?$/ =~ line)
          @entries["__newline__#{newline_count}"] = { "newline" => "newline" }
          newline_count += 1
          next
        end

        # Remove comment, if there is one
        line_and_comment = line.split("#")
        line = line_and_comment[0]
        comment = line_and_comment[1]

        # Remove newline from comment
        comment = comment[0..-2] if (comment != nil)

        parts = line.split(/[\s\t]+/)

        dest      = parts[0]
        hostnames   = parts[1..-1]

        # Remove last item if empty
        hostnames.pop if (hostnames.length == 0)

        hostnames = [hostnames] if (!hostnames.is_a?(Array))

        if (hostnames == nil)
          fail InvalidHostsFileException.new "Missing hostsname from entry declaration \n #{line}\n"
        end
        if (dest == nil)
          fail InvalidHostsFileException.new "Missing destination from entry declaration \n #{line}\n"
        end

        add_entry(dest, hostnames, comment)
      end
    end

    # Return false if the hostname
    # was not an alias for 'dest'
    def rm_alias(dest, hostname)
      return false if (!@entries.has_key?(dest))

      # remove hostname from dest, and return
      # bool to indicate if it existed in the
      # first place
      was_deleted = @entries[dest]["hostnames"].delete(hostname) != nil;

      # remove dest from @entries
      # if it is now empty
      if (@entries[dest]["hostnames"].length == 0)
        @entries.delete(dest)
      end

      return was_deleted
    end

    def rm_dest_entries(dest)
      if (@entries.has_key?(dest))
        @entries.delete(dest)
      end
    end

    # Add an entry.
    # Expects to strings
    def add_entry(dest, hostnames, comment = nil)
      comment = "" if comment == nil

      hostnames = [hostnames] if (!hostnames.is_a?(Array))

      if (@entries.has_key?(dest))
        # Add hostnames to entries, except duplicates, dont add them
        @entries[dest]["hostnames"] = @entries[dest]["hostnames"] | hostnames
      else
        @entries[dest] = {"hostnames" => hostnames, "comment" => comment}
      end
    end

    def get_all_entries()
      _entries = {}
      @entries.each do |dest, obj|
        next if (!obj.has_key?("hostnames"))
        _entries[dest] = obj["hostnames"]
      end
      return _entries
    end

    # Flush changes made to
    # hosts file
    def flush()
      new_hosts_file_content = ''
      longest_dest_name = 0

      @entries.each do |dest, obj|
        next unless (obj.has_key?("hostnames"))
        if (dest.length > longest_dest_name)
          longest_dest_name = dest.length
        end
      end

      longest_dest_name += 1

      @entries.each do |dest, obj|
        if (obj.has_key?('comment') && !obj.has_key?('hostnames'))
          new_hosts_file_content << obj['comment'] << "\n"
        elsif (obj.has_key?('newline'))
          new_hosts_file_content << "\n"
        else
          new_hosts_file_content << ("%-#{longest_dest_name}.#{longest_dest_name}s" % dest)
          new_hosts_file_content << (obj['hostnames'] * ' ')
          
          if (obj['comment'].length > 0)
            comment = obj['comment']
            # If it for some reason is not formated
            # as a comment
            unless (/^[\s\t]*?#/ =~ comment)
              comment = '#' + comment
            end
            new_hosts_file_content += ("\s" + comment)
          end
          
          new_hosts_file_content << "\n"
        end
      end

      puts
      puts "new content of hosts file:"
      puts new_hosts_file_content
      puts

      File.open(@hosts_file_path, "w+").write(new_hosts_file_content)
    end
  end

  class InvalidHostsFileException < Exception
  end
end

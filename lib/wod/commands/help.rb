module Wod::Command
  class Help < Base
    class HelpGroup < Array
      attr_reader :title

      def initialize(title)
        @title = title
      end

      def command(name, description)
        self << [name, description]
      end

      def space
        self << ['', '']
      end
    end
    
    def self.groups
      @groups ||= []
    end

    def self.group(title, &block)
      groups << begin
        group = HelpGroup.new(title)
        yield group
        group
      end
    end

    def self.create_default_groups!
      return if @defaults_created
      @defaults_created = true
      group 'General Commands' do |group|
        group.command 'help',                         'show this usage'
        group.command 'version',                      'show the gem version'
        group.space
        group.command 'login',                        'log in with your apple credentials'
        group.command 'logout',                       'clear local authentication credentials'
        group.space
        group.command 'auth:direct_login <username> <password> <team name>', 'log in with your apple credentials without any additional user input'
        group.space
        group.command 'devices',                         'list your registered devices'
        group.command 'devices:add <name> <udid>',      'add a new device'
        group.command 'devices:remove <name>',      'remove device (Still counts against device limit)'
        group.space
        group.command 'profiles',                      'list your distribution provisioning profiles'
        group.command 'profiles:get <name> <dest>', 'get a profile with the specified name and save it to the destination file'
      end
    end    
    
    def index
      puts usage
    end
    
    def usage
      puts "wod v#{Wod::VERSION}"
      puts
      
      longest_command_length = self.class.groups.map do |group|
        group.map { |g| g.first.length }
      end.flatten.max
      
      self.class.groups.inject(StringIO.new) do |output, group|
        output.puts "=== %s" % group.title
        output.puts
      
        group.each do |command, description|
          if command.empty?
            output.puts
          else
            output.puts "%-*s # %s" % [longest_command_length, command, description]
          end
        end
      
        output.puts
        output
      end.string
    end

  end
end

Wod::Command::Help.create_default_groups!
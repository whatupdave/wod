require 'readline'

module Wod::Command
  class Auth < Base
    attr_accessor :credentials
    
    def client
      @client = Wod::Client.new :collect_login_deets => lambda { [user, password] },
                                :collect_team_selection => lambda { |team_names| team || collect_team_selection(team_names) }
    end
        
    # just a stub; will raise if not authenticated
    def check
      client.logged_in?
    end
    
    def reauthorize
      @credentials = ask_for_and_save_credentials
    end
    
    def user
      credential 0
    end
    
    def password
      credential 1
    end
    
    def team
      credential 2
    end
    
    def credential index
      get_credentials
      @credentials && @credentials.size > index ? @credentials[index] : nil
    end
    
    def credentials_file
      "#{home_directory}/.wod/credentials"
    end
    
    def get_credentials
      return if @credentials
      unless @credentials = read_credentials
        ask_for_and_save_credentials
      end
      @credentials
    end
    
    def read_credentials
      File.exists?(credentials_file) and File.read(credentials_file).split("\n")
    end
    
    def echo_off
      system "stty -echo"
    end
    
    def echo_on
      system "stty echo"
    end
    
    def ask_for_credentials
      puts "Enter your apple credentials"
      
      print "Apple ID: "
      user = ask
      
      print "Password: "
      password = ask_for_password

      [user, password]
    end
    
    def ask_for_password
      echo_off
      password = ask
      puts
      echo_on
      return password
    end
    
    def ask_for_and_save_credentials
      begin
       @credentials = ask_for_credentials
       write_credentials
       check
      rescue ::Wod::InvalidCredentials
        delete_credentials
        @client = nil
        @credentials = nil
        puts "Authentication failed."
        return if retry_login?
        exit 1
      end
    end
    
    def collect_team_selection team_names
      puts "This account belongs to the following teams:"
      team_names.each_with_index do |team, i|
        puts "#{i+1}. #{team}"
      end
      print "Select team (1): "
      selection = ask
      selection = "1" if selection.empty? || selection.to_i == 0
      @credentials[2] = team_names[selection.to_i-1]
      write_credentials
      @credentials[2]
    end
    
    def retry_login?
      @login_attempts ||= 0
      @login_attempts += 1
      @login_attempts < 3
    end
    
   def write_credentials
      FileUtils.mkdir_p(File.dirname(credentials_file))
      File.open(credentials_file, 'w') do |f|
        f.chmod(0600)
        f.puts self.credentials
      end
      set_credentials_permissions
    end
    
    def set_credentials_permissions
      FileUtils.chmod 0700, File.dirname(credentials_file)
      FileUtils.chmod 0600, credentials_file
    end

    def delete_credentials
      FileUtils.rm_rf "#{home_directory}/.wod/"
    end
    
    def direct_login
      begin
        user = args.shift
        password = args.shift
        team_name = args.shift
        @credentials = [user, password, team_name]
        write_credentials
        check
      rescue ::Wod::InvalidCredentials
        delete_credentials
        @client = nil
        @credentials = nil
        puts "Authentication failed."
        exit 1
      end
    end
  end
end
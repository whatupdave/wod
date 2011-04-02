require 'rubygems'
require 'mechanize'
require 'wod/helpers'
require 'wod/version'

module Wod
  class DevCenterPage
    attr_reader :page
    
    def initialize page
      @page = page
    end
    
    def logged_in?
      (page.title =~ /sign in/i) == nil && (page.search("span").find {|s| s.text == "Log in"}) == nil
    end
    
    def team_selection_page?
      (page.title =~ /select.*team/i)
    end
    
    def search arg
      @page.search arg
    end
    
    def form arg
      @page.form arg
    end
  end
  

  class Client
    include Wod::Helpers
  
    def self.last_page
      @@last_page
    end
  
    attr_reader :collect_login_deets, :collect_team_selection
    def initialize options
      @collect_login_deets = options[:collect_login_deets]
      @collect_team_selection = options[:collect_team_selection]
    end
  
    def cookies_file
      "#{home_directory}/.wod/cookie_jar"
    end
    
    def create_agent
      agent = Mechanize.new
      agent.cookie_jar.load cookies_file if File.exists?(cookies_file)
      agent
    end
  
    def agent
      @agent ||= create_agent
    end
    
    def login_at page
      login_page = page.page.links.find { |l| l.text == 'Log in'}.click

      username, password = collect_login_deets.call

      f = login_page.form("appleConnectForm")
      f.theAccountName = username
      f.theAccountPW = password
      f.submit
    end
    
    def select_team_at page
      f = page.form "saveTeamSelection"
      select_list = f.field('memberDisplayId')
      teams = select_list.options.map(&:text)
      
      selected_team = collect_team_selection.call(teams)
      select_list.option_with(:text => selected_team).select
      
      f.click_button f.button_with(:value => /continue/i)
    end
    
    def login_and_reopen url
      page = DevCenterPage.new agent.get("https://developer.apple.com/devcenter/ios/index.action")

      unless page.logged_in?
        login_at page
        page = DevCenterPage.new agent.get url
      end
      
      if page.team_selection_page?
        select_team_at page
        page = DevCenterPage.new agent.get url
      end
      
      raise InvalidCredentials unless page.logged_in?
      agent.cookie_jar.save_as cookies_file
      page
    end

    def get url
      page = DevCenterPage.new agent.get(url)
      page = login_and_reopen(url) unless page.logged_in?
      @@last_page = page
    end
    
    def logged_in?
      page = get "https://developer.apple.com/devcenter/ios/index.action"
      page.logged_in? && !page.team_selection_page?
    end
  
  end
end
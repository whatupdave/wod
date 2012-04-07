require 'net/https'
require 'uri'


module Wod::Command
  class Profiles < Base
    def index
      page = wod.get "https://developer.apple.com/ios/manage/provisioningprofiles/viewDistributionProfiles.action"

      distribution_profiles = []
      
      profiles = page.search("td.profile")
      profiles.each { |profile|
        tr = profile.parent
        
        name = profile.search("span").text
        link = tr.search("td.action a[id='remove_']").first[:href]
        
        link = "https://developer.apple.com#{link}"
        
        distribution_profiles << {:name => name, :link => link}
      }
      
      display_formatted distribution_profiles, [:name, :link]
    end
    
    def get
      req_name = args.shift
      req_destination = args.shift
      
      page = wod.get "https://developer.apple.com/ios/manage/provisioningprofiles/viewDistributionProfiles.action"

      link_to_get = nil
      
      profiles = page.search("td.profile")
      profiles.each { |profile|
        tr = profile.parent
        
        name = profile.search("span").text
        
        if (name == req_name)
          link = tr.search("td.action a[id='remove_']").first[:href]
          
          link_to_get = "https://developer.apple.com#{link}"
        end
      }
      
      if (link_to_get != nil)
        file_content = wod.getfile link_to_get
        file_content.save(req_destination)
      end
    end
  end
end
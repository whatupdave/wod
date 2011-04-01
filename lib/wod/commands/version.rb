module Wod::Command
  class Version < Base
    def index
      puts Wod::Client.gem_version_string
    end
  end
end
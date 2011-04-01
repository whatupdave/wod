module Wod::Command
  class Version < Base
    def index
      puts "wod v#{Wod::VERSION}"
    end
  end
end
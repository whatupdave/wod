require 'readline'

module Wod::Command
  class App < Base
    def login
      Wod::Command.run_internal "auth:reauthorize", args.dup
    end
    
    def logout
      Wod::Command.run_internal "auth:delete_credentials", args.dup
      puts "Local credentials cleared."
    end
    
  end
end
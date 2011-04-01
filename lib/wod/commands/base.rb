require 'fileutils'

module Wod::Command
  class Base
    include Wod::Helpers
    
    attr_accessor :args
    
    def initialize(args, wod=nil)
      @args = args
      @wod = wod
    end
    
    def wod
      @wod ||= Wod::Command.run_internal('auth:client', args)
    end
  end
end
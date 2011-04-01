module Wod
  class InvalidCredentials < RuntimeError; end
  class NoTeamSelected < RuntimeError
    attr_reader :teams
    def initialize(teams)
      @teams = teams
    end
  end
end

require 'wod/client'
require 'wod/command'
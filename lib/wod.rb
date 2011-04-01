module Wod
  class InvalidCredentials < RuntimeError; end
end

require 'wod/client'
require 'wod/command'
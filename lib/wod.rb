module Wod
  class InvalidCredentials < RuntimeError; end
end

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

puts $:

require 'wod/client'
require 'wod/command'
require "bowndler/version"
require "bowndler/hook"

module Bowndler
  def self.hook
    Bowndler::Hook.create
  end
end


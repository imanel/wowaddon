require "wowaddon/version"

module Wowaddon
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Config, "#{ROOT}/wowaddon/config"

  def self.config
    @config ||= Config.new
  end
end

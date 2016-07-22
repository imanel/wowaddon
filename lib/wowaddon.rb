require "wowaddon/version"

module Wowaddon
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Config, "#{ROOT}/wowaddon/config"
  autoload :DatabaseDownloader, "#{ROOT}/wowaddon/database_downloader"
  autoload :Package, "#{ROOT}/wowaddon/package"

  def self.config
    @config ||= Config.new
  end
end

require 'active_record'
require 'oga'
require 'open-uri'

module Wowaddon
  class Package < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: Wowaddon.config.database_file

    def changelog
      return @changelog if defined? @changelog
      url = "https://mods.curse.com/addons/wow/" + curse_id
      file = open url
      document = Oga.parse_html file
      @changelog = document.css("#tab-changes").text.strip
    end
  end
end

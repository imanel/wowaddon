require 'active_record'

module Wowaddon
  class Package < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: Wowaddon.config.database
  end
end

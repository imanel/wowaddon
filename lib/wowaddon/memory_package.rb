module Wowaddon
  class Package < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory'
  end
end

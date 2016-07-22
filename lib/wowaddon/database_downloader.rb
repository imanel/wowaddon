require 'active_record'
require 'bzip2/ffi'
require 'json'
require 'open-uri'
require 'sqlite3'

module Wowaddon
  class DatabaseDownloader
    SOURCE_URL = "http://clientupdate.curse.com/feed/Complete.json.bz2"
    UPDATE_THRESHOLD = 3 * 60 * 60 # 3 hours

    def initialize(source = SOURCE_URL)
      @source = source
    end

    def download(force = false)
      return unless force || needs_download?
      print "Downloading new database..."
      file = open(@source)
      json = convert_to_json file
      write_to_database json
      save_database_timestamp
      puts " done."
    end

    private

    def needs_download?
      return true if Wowaddon.config.database_timestamp.nil?
      last_update = Time.parse(Wowaddon.config.database_timestamp)
      Time.now - last_update > UPDATE_THRESHOLD
    end

    def convert_to_json(data)
      uncompressed = Bzip2::FFI::Reader.open data
      JSON.parse uncompressed.read
    end

    def write_to_database(json)
      write_to_memory_database(json)
      copy_to_disk_database
    end

    def write_to_memory_database(json)
      prepare_memory_database
      json.each do |row|
        TempPackage.create name: row['Name'], version: row['LatestFiles'][0]['FileName']
      end
    end

    def prepare_memory_database
      ActiveRecord::Migration.verbose = false
      ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
      ActiveRecord::Schema.define do
        create_table :packages do |t|
          t.text :name, collation: 'NOCASE'
          t.text :version
        end
      end
    end

    def copy_to_disk_database
      backup = SQLite3::Backup.new(Package.connection.raw_connection, 'main', TempPackage.connection.raw_connection, 'main')
      backup.step(-1)
      backup.finish
    end

    def save_database_timestamp
      Wowaddon.config.update(:database_timestamp, Time.now.iso8601)
    end

    class TempPackage < ActiveRecord::Base
      self.table_name = :packages
    end
  end
end

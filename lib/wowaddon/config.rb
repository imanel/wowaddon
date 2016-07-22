require 'json'

module Wowaddon
  class Config
    def initialize
      create_config unless config_exists?
    end

    def data
      return @data if defined? @data
      raw_data = JSON.parse(File.read(file)) rescue default_config
      @data = OpenStruct.new raw_data
    end

    def dir
      @config_dir ||= File.join(Dir.home, '.wowaddon')
    end

    def file
      @config_file ||= File.join(dir, 'config.json')
    end

    def save
      File.open(file, 'w') {|f| f.write(JSON.pretty_generate(data.to_h)) }
    end

    def update(field, value)
      @data[field] = value
      save
    end

    private

    def config_exists?
      File.exist? file
    end

    def create_config
      FileUtils.mkdir_p dir
      save
    end

    def default_config
      {
        addons_dir: File.join('/', 'Applications', 'World of Warcraft', 'Interface', 'AddOns'),
        database_file: File.join(dir, 'database.sqlite3')
      }
    end

    def method_missing(method, *args, &block)
      data.send(method, *args, &block)
    end
  end
end

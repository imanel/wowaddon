require 'json'

module Wowaddon
  class Config
    def initialize
      create_config unless config_exists?
    end

    def data
      @data ||= OpenStruct.new JSON.parse(File.read(file))
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

    private

    def config_exists?
      File.exist? file
    end

    def create_config
      Dir.mkdir dir
      File.open(file, 'w') {|f| f.write("{}") }
    end
  end
end

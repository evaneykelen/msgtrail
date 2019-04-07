module Msgtrail
  class Config

    CONFIG_FILE = 'config.json'.freeze

    attr_accessor :settings, :working_directory

    def initialize(working_directory)
      self.working_directory = working_directory # Used by several classes
      begin
        filepath = File.join(working_directory, CONFIG_FILE)
        config = File.read(filepath)
      rescue
        puts("Can't find '#{filepath}'")
        exit(2)
      end
      begin
        self.settings = MultiJson.load(config, symbolize_keys: true, object_class: OpenStruct)
      rescue
        puts("Invalid JSON in '#{filepath}'")
        exit(2)
      end
    end

  end
end

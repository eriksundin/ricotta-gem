require 'yaml'

module Ricotta::Configuration
    class Config
    
    def initialize(rcfile)
      @config = Hash.new
      parse(File.expand_path('~/.ricottarc'))
      parse('.ricottarc')
      parse(rcfile)
    end
    
    def [](key)
      return @config["#{key}"]
    end
    
    private
    
    def parse(file)
      if file and File.exist?(file)
        YAML.load_file(file).each {|key, value| @config[key] = value }
      end
    end

  end  
end
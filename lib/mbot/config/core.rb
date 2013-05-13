module MBot
  require 'ostruct'
  require 'yaml'
  class Config < OpenStruct
    def initialize file=nil
      super()
      @file = file.to_s
    end
    def load
      marshal_load YAML.load_file @file if File.exists? @file
    end
    def save
      File.write @file, YAML.dump(marshal_dump)
    end

    def process_cfg cfg
      @file = (cfg.delete 'file' or File.join Config::ROOT, Config::FILE)
      load
      cfg.each do |key, value|
        send "#{key}=", value
      end
      unless CFG.server and CFG.server[:host] and CFG.bot and CFG.bot[:nick]
        require 'mbot/config/bootstrap'
      end
      Log.file = CFG.log if CFG.log
    end
  end
end

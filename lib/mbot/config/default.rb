module MBot
  class Config
    DEBUG        = $DEBUG
    SOCKET_READ  = 512
    PLUG_DIR     = File.join MBot::Directory, 'plugin'
    ROOT         = File.join ENV['HOME'], '.config', 'mbot'
    PLUG_DATADIR = File.join ROOT, 'plugin'
    FILE         = 'config'
  end
  class << self
    attr_accessor :sleep, :plugin
  end
end

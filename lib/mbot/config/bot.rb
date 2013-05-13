module MBot
  require 'mbot/sleep'
  require 'mbot/config/core'
  require 'mbot/config/default'
  MBot.sleep = Sleep.new
  CFG = Config.new
end

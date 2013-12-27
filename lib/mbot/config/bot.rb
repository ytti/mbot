module MBot
  require 'mbot/sleep'
  require 'mbot/queue'
  require 'mbot/config/core'
  require 'mbot/config/default'
  MBot.sleep = Sleep.new
  MBot.queue = Queue.new
  CFG = Config.new
end

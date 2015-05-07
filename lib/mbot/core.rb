module MBot
  require 'mbot/config/bot'
  require 'mbot/log'
  require 'mbot/io'
  require 'mbot/bot/core'
  require 'mbot/plugin/core'

  class << self
    def new cfg={}
      mbot = MBot::Core.new cfg
      mbot.bot
    end
  end

  class Core
    alias _loop loop
    attr_reader :bot, :pm, :im
    def initialize cfg
      CFG.process_cfg cfg
      @pm  = PluginManager.new
      @im  = IOManager.new @pm
      @bot = Bot.new self
      MBot.queue.bot = @bot
    end

    def loop 
      begin
        _loop do
          MBot.queue.serve
          ios, _, _ = select @im.io, nil, nil, MBot.sleep.to_i
          on_io ios if ios
          on_loop
        end
      ensure
        @bot.quit 'I wonder, will I dream?'
      end
    end

    def on_loop
      @pm.plugin.each do |name, plugin|
        plugin[:instance].send :on_loop if plugin[:instance].respond_to? :on_loop
      end
    end

    def on_io ios
      ios.each do |io|
        @im.cb_by_io(io).each do |cb|
          cb.send :on_io, io if cb.respond_to? :on_io
        end
      end
    end
  end
end

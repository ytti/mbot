module MBot
  require 'mbot/net'
  require 'mbot/bot/irc'
  require 'mbot/bot/helper'
  require 'mbot/user'
  require 'mbot/message'

  class Bot
    attr_reader :core
    alias _load load
    def initialize core
      @core        = core
      @core.pm.bot = self
      @n           = MBot::Net.new self
      init
    end

    def loop
      @core.loop
    end

    def load plugin
      @core.pm.load plugin
    end

    def unload plugin
      @core.pm.unload plugin
    end

    def plugins
      @core.pm.plugin
    end

    def io name
      @core.pm.io name
    end

    def on_cmd cmd, src, dst, data
      case cmd.to_sym
      when :PING
        pong data
      when :PRIVMSG
        cmd_privmsg User.new(src), dst, data
      when :NOTICE
        # i'll get to it
      else
        Log.debug "unsupported: #{cmd}, #{src}, #{dst}, #{data}"
      end
    end

    def init
      CFG.channel.each do |channel|
        join channel.split
      end if CFG.channel.respond_to? :each
      CFG.plugin[:load].each do |plugin|
        load plugin
      end if CFG.plugin and CFG.plugin[:load].respond_to? :each
    end


    def send_cmd cmd, dst, data=nil
      return if Log.missing_arg cmd, dst
      data = data ? ' :' + data : ''
      @n.write "%s %s%s" % [cmd, dst, data]
    end

    private

    def cmd_privmsg user, dst, data
      if dst == CFG.bot[:nick]
        msg_input Message.new(user, data, dst, :private)
      else
        msg_input Message.new(user, data, dst, :channel)
      end
    end

    def msg_input message
      @message = message
      # we might modify the list (plugin might add/remove plugin)
      plugs = @core.pm.plugin.keys
      plugs.each do |name|
        plug = @core.pm.plugin[name]
        return unless plug # plugin might have gone away
        if @message.to_bot?
          cb_handler :to_bot, plug, @message.to_bot
          cb_handler :on_msg, plug, @message.to_bot
        else
          cb_handler :on_msg, plug, @message
        end
      end
    end

    def cb_handler type, plug, trigger=@message
      cmd = nil
      return unless hit = plug[:cmd].find { |re| cmd=re.match trigger }
      plugin = plug[:instance]
      return unless plugin.respond_to? type
      @message.add cmd[0], trigger.sub(hit, '')
      plugin.send :msg=, @message
      plugin.send type
    end

  end
end


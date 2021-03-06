module MBot
  require 'mbot/bot/meta'
  class Bot

    def pong server
      send_cmd 'PONG', '', server
    end

    def event_376
      CFG.channel.each do |channel|
        join channel.split
      end if CFG.channel.respond_to? :each
    end

    def join channel, key=nil
      send_cmd 'JOIN', [channel, key.to_s].join(' ')
    end

    def privmsg msg, dst=nil
      dst ||= @message.src
      MBot.queue.add dst, msg
    end
    alias :msg :privmsg

    def say msg, dst=nil
      msg = @message.nick + ', ' + msg.to_s if @message.channel
      privmsg msg, dst
    end
    alias :reply :say

    def notice msg, dst=nil
      dst ||= @message.src
      send_cmd 'NOTICE', dst, msg
    end

    def kick nick=nil, channel=nil, msg='no reason'
      nick    ||= @message.nick
      channel ||= @message.channel
      return if Log.missing_arg nick, channel
      send_cmd  'KICK', [channel, nick].join(' '), msg
    end

    def channel_mode mode, nick=nil, channel=nil
      nick    ||= @message.nick
      channel ||= @message.channel
      return if Log.missing_arg mode, nick, channel
      msg = [channel, mode, nick].join ' '
      send_cmd 'MODE', msg
    end

    def quit msg=''
      send_cmd 'QUIT', '', msg
      @n.quit
    end
  end
end

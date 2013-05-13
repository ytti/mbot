module MBot
  class Message < String
    attr_accessor :user, :target, :type, :nick, :channel, :src, :cmd, :arg
    def initialize user, message, target, type
      @user    = user
      @target  = target
      @type    = type
      @nick    = @user.nick
      @channel = @type == :channel ? @target : nil
      @src     = (@channel or @nick)
      super message
    end
    def is other
      self == other
    end
    def has other
      match(/(?:^|\s)#{other}(?:\s|$)/)
    end
    def start str
      match(/^#{str}\s*(.*)/) ? $1 : nil
    end
    def add cmd, arg
      @cmd = dup.replace cmd
      @arg = dup.replace arg.lstrip
    end
    def to_bot
      msg = dup
      if @type == :channel
        match(/^\s*#{CFG.bot[:nick]}[\s,:]+(.*)/) ? msg.replace($1) : msg.replace('')
      end
      msg
    end
    def to_bot?
      not to_bot.empty?
    end
  end
end

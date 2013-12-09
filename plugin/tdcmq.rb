class TDCMQ < Plugin

require 'tdc/mq'
cmd %w(mute unmute) 

  def initialize *arg
    super
    @muted = nil
    @mq = TDC::MQ.new 'mmmbop'
    @mq.join 'dispatch/irc'
    io << @mq.socket
  end

  def on_msg
    if msg.cmd == 'mute'
      @muted = Time.now + 60*30
      bot.say bot.clr :lred, 'muted ', "until #{@muted}"
    else
      @muted = false
      bot.say bot.clr :lgreen, 'unmuted'
    end
  end

  def mute dst
    if @muted
      @muted = false if Time.now > @muted
    end
    return false unless dst.match(/alarm/)
    @muted
  end

  def on_io io
    while @mq.msg?
      msg    = @mq.get
      target = msg['target']
      msg    = msg['msg']
      bot.msg msg, target unless mute(target)
    end
  end

end

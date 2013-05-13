class UDP < Plugin

cmd %w(mute unmute) 

  def initialize *arg
    super
    @muted = nil
    port = cfg.port
    unless port
      port = 'bot'.to_i 36
      cfg.port = port
      cfg.save
    end
    udp = UDPSocket.new
    udp.bind '0.0.0.0', port
    io << udp
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

  def on_io udp
    mesg = ''
    begin 
      loop { mesg << udp.read_nonblock(1024) }
    rescue Errno::EAGAIN
    end
    mesg.split(/\n/).each do |m|
      dst, m = m.split(/\s+/, 2)
      bot.msg m, dst unless mute(dst)
    end
  end

end

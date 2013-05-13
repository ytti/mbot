class Memo < Plugin

  def to_bot
    time, usr_msg = msg.arg.split ' ', 2
    return unless usr_msg
    return unless (time = str2sec(time) rescue nil)
    cfg.entries ||= []
    cfg.entries.push [time.to_i, msg.nick, usr_msg]
    cfg.save
    MBot.sleep.for :memo, next_expiry
    bot.notice "reminding you at #{time}", msg.nick
  end

  def on_loop
    return unless cfg.entries
    expired = []
    cfg.entries.delete_if { |e| expired << e if Time.now.to_i >= e[0] }
    cfg.save
    MBot.sleep.for :memo, cfg.entries.empty? ? nil : next_expiry
    expired.each { |time, nick, mesg| bot.say mesg, nick }
  end

  def str2sec str
    sec = nil
    case str
    when  /^(\d+)h$/
     sec = $1.to_i*60*60
    when /^(\d+)m(?:in)?$/
     sec = $1.to_i*60
    when /^(\d+)h(\d+)m(?:in)?$/
     sec = $1.to_i*60*60
     sec += $2.to_i*60
    when /^(\d{1,2}):(\d{1,2})$/
     time_want = Time.new( *Time.now.strftime('%Y %m %d').split,
                           $1, $2, nil, nil )
     sec = (time_want-Time.now).to_i
    end
    sec = nil unless sec > 0
    sec = (Time.now + sec) if sec
    sec
  end

  def next_expiry
    expires = cfg.entries.sort_by { |e| e[0] }.first 
    expires ? (expires[0] - Time.now.to_i) : CFG.sleep
  end

end

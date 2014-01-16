module MBot

  MAX_BUCKET        = 5.0  # How many messages to burst
  INTER_MESSAGE_GAP = 1.8  # How long to wait between sending messages
  MAX_QUEUE         = 20   # How long until queue overflows

  class Queue
    attr_accessor :bot
    def initialize bot=nil
      @bot        = bot
      @queue      = []
      @tokens     = MAX_BUCKET
      @next_token = Time.now
    end

    def add dst, msg
      MBot.sleep.for :queue, 0.05
      @queue << [dst, msg]
    end

    def serve
      overflow
      while @tokens>0 and msg=@queue.shift
        @tokens -= 1
        @bot.send_cmd 'PRIVMSG', msg.first, msg.last
      end

      if Time.now>@next_token and @tokens<MAX_BUCKET
        @tokens += 1
        @next_token = Time.now + INTER_MESSAGE_GAP
      end

      sleep = @queue.size == 0 ? nil : INTER_MESSAGE_GAP
      MBot.sleep.for :queue, sleep
    end

    def overflow
      if @queue.size > MAX_QUEUE
        msgs = @queue.shift @queue.size-MAX_QUEUE
        alarm = "#{msgs.size} messages dropped due to queue full"
        @queue.unshift [CFG.bot[:control], alarm]
        Log.warn alarm
      end
    end

  end

end

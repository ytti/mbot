module MBot
  BURST = 4
  DELAY = 2
  MAX_QUEUE = 10
  class Queue
    attr_accessor :bot
    def initialize bot=nil
      @queue = []
      @bot = bot
    end
    def add dst, msg
      MBot.sleep.for :queue, 0.1
      @queue << [dst, msg]
    end
    def serve
      MBot.sleep.for :queue, nil
      if @queue.size > MAX_QUEUE
        msgs = @queue.shift @queue.size-MAX_QUEUE
        alarm = "#{msgs.size} messages dropped due to queue full"
        @bot.send_cmd 'PRIVMSG', CFG.owner[:nick], alarm
        Log.warn alarm
        msgs.each do |msg|
          Log.warn msg.join ' -> '
        end
      end
      @queue.shift(BURST).each do |msg|
        @bot.send_cmd 'PRIVMSG', msg.first, msg.last
      end
      sleep DELAY+1 unless @queue.empty?
      while msg = @queue.shift
        @bot.send_cmd 'PRIVMSG', msg.first, msg.last
        sleep DELAY
      end
    end
  end
end

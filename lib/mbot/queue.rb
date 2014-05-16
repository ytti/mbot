module MBot

  MAX_BUCKET        = 5.0  # How many messages to burst
  MAX_QUEUE         = 20   # How long until queue overflows
  INTER_MESSAGE_GAP = 2.1  # How long to wait between sending messages

  class Queue
    attr_accessor :bot
    attr_reader :tokens
    def initialize bot=nil
      @bot        = bot
      @queue      = Hash.new{|h,k|h[k]=[]}
      @tokens     = MAX_BUCKET
      @next_token = Time.now
    end

    def add dst, msg
      MBot.sleep.for :queue, 0.05
      @queue[dst] << msg
    end

    def serve
      taildrop
      while @tokens>0 and msg=dequeue
        @tokens -= 1
        @bot.send_cmd 'PRIVMSG', msg[:target], msg[:msg]
      end

      if @tokens<MAX_BUCKET and Time.now>@next_token
        @tokens += 1
        @next_token = Time.now + INTER_MESSAGE_GAP
        if @tokens < MAX_BUCKET
          MBot.sleep.for :queue, INTER_MESSAGE_GAP
        else
          MBot.sleep.for :queue, nil
        end
      end
    end
   
    def dequeue
      if @queue.empty?
        nil
      else
        target = @queue.keys.sample
        msg    = @queue[target].shift
        @queue.delete target if @queue[target].empty?
        {:target=>target, :msg=>msg}
      end
    end

    def taildrop
      alarms = []
      @queue.each do |target, msg|
        if @queue[target].size > MAX_QUEUE
          msgs  = @queue[target].shift @queue[target].size-MAX_QUEUE
          alarms << "#{msgs.size} messages to #{target} dropped due to queue full"
        end
      end
      alarms.each do |alarm|
        @queue[CFG.bot[:control]].unshift alarm
        Log.warn alarm
      end
    end

  end

end

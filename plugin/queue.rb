class Queue < Plugin
  def to_bot
    bot.say MBot.queue.tokens.inspect
  end
end

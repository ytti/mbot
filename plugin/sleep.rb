class Sleep < Plugin
  def to_bot
    bot.say MBot.sleep.to_f.inspect
  end
end

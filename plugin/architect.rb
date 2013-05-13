class Architect < Plugin
  def to_bot
    bot.voice
    bot.deop
  end
end

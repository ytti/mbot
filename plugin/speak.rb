class Speak < Plugin
  def to_bot
    bot.say bot.clr :lblue, 'qwaaak', ' kvaat', :lgreen, ' quack'
  end
  def on_msg
    bot.say 'i still want to qwaak'
  end
end

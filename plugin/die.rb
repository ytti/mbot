class Die < Plugin
  def to_bot
    return unless msg.user.owner?
    bot.quit "Death requested by #{msg.nick}"
  end
end

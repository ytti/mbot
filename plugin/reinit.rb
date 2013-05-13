class ReInit < Plugin
  def to_bot
    return unless msg.user.owner?
    bot.init
  end
end

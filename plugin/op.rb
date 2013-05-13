class Op < Plugin
  def to_bot
    return unless msg.user.owner?
    bot.op
  end
end

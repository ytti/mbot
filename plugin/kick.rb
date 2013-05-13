class Kick < Plugin
  def to_bot
    return unless msg.user.owner?
    nick = msg.arg or msg.nick
    bot.kick nick, nil, "requsted by #{msg.nick}"
  end
end

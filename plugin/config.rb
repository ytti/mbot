class Config < Plugin
  def to_bot
    return unless msg.user.owner?
    if msg.arg.is 'load'
      CFG.load
      bot.say "Configuration loaded"
    elsif msg.arg.is 'save'
      CFG.save
      bot.say "Configuration saved"
    end
  end
end

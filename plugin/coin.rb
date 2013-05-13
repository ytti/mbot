class Coin < Plugin
  def on_msg
    bot.say %w(heads tails).at rand(2)
  end
end

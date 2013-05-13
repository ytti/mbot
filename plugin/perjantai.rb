class Perjantai < Plugin
  cmd [
        /perjantai\?/i,
        /mikä päivä/i
      ]
  def on_msg
    bot.say Time.now.friday? ? 'PERJANTAI!!1' : 'Perjantai.'
  end
end

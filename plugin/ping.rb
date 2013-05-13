class Ping < Plugin
  cmd [ 'pong',
        /\s*paljonko viive/i,
        'ping',
      ]
  def on_msg
    bot.say 'pong'
  end
end

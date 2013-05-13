class Plug < Plugin
  def to_bot
    return unless msg.user.owner?
    arg = msg.arg
    if plug = arg.start('load')
      tell_status :load, plug, bot.load(plug)
    elsif plug = arg.start('unload')
      tell_status :unload, plug, bot.unload(plug)
    elsif plug = arg.start('reload')
      if tell_status :unload, plug, bot.unload(plug)
         tell_status :load, plug, bot.load(plug)
      end
    else
      bot.say "loaded plugins: #{bot.plugins.map{|name,plugin|name}.join(', ')}"
    end
  end

  def tell_status op, plug, status
    ok = nil
    if status.first == :ok
      ok = bot.say "#{plug} #{op} ok"
    else
      bot.say "#{plug} #{op} failed"
    end
    ok
  end
end

class Fifo < Plugin

  def initialize *arg
    super
    fifo = cfg.fifo
    unless fifo
      fifo = File.join Config::ROOT, 'fifo'
      cfg.fifo = fifo
      cfg.save
    end
    io << open(fifo, 'r+')
  end

  def on_io fifo
    loop { bot.say fifo.read_nonblock(512) } rescue Errno::EAGAIN
  end

end

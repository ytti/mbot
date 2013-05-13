module MBot

  require 'socket'
  class Net
    def initialize bot
      @bot = bot
      port = (CFG.server[:port] or 6667)
      connect CFG.server[:host], port
    end

    def quit
      @n.close
    end

    def write data
      @n.write data + "\n"
    end

    def on_io io
      #@n = io
      read.each_line { |msg| message_handler msg }
    end

    private 

    def connect host ,port
      @n = TCPSocket.new host, port
      @bot.core.im.push IOCB.new @n, self
      login
    end

    def login
      write 'user ' + (CFG.bot[:user] or CFG.bot[:nick]) + ' 0 0 :' + (CFG.bot[:name] or CFG.bot[:nick])
      loop do
        write 'nick ' + CFG.bot[:nick]
        if @n.readline.match(/ 433 .*:Nickname is already in use/)
          CFG.bot[:nick] += (97 + rand(26)).chr
          CFG.save
        else
          break
        end
      end
    end

    def read
      input, try, tried = '', 5, 0
      begin
        loop { input += @n.read_nonblock Config::SOCKET_READ }
      rescue Errno::EAGAIN
        if input[-1] != "\n"
          sleep 0.05
          retry if (tried+=1) <= try
        end
      end
      input
    end

    def message_handler msg
      Log.debug msg
      src, cmd, dst, data = msg.chomp.split ' ', 4
      if not dst     # e.g. pong
        cmd, data = src, cmd
      elsif not data # e.g. join
        data = dst
      end
      @bot.on_cmd cmd, src, dst, data[1..-1]
    end
  end

end

require 'logger'
module MBot
  class MBotLog < Logger
    def initialize target=STDOUT
      super target
      self.level = MBot::Config::DEBUG ? Logger::DEBUG : Logger::INFO
    end
    def file= target
      @logdev = LogDevice.new target
    end
    def missing_arg *args
      if args.any? { |arg| not arg }
        warn "#{caller[0]} had undefined arguments - #{args.inspect}"
      else
        false
      end
    end
  end
  Log = MBotLog.new
end

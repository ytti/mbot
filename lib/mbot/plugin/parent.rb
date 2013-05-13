module MBot
  class Plugin
    attr_accessor :msg
    attr_reader :bot
    def initialize bot
      @bot       = bot
      @plug_file = Plugin.class2name self.class
      @plug_file = File.join CFG.plugin[:datadir], @plug_file + '.cfg'
      @cfg       = nil
    end 
    def cfg
      unless @cfg
        @cfg =  Config.new @plug_file
        @cfg.load
      end
      @cfg
    end
    def io 
      @bot.io self.class
    end
  end
end

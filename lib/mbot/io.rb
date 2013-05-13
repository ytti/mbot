module MBot
  class IOCB
    attr_accessor :io, :cb
    def initialize io, cb
      @io = io
      @cb = cb
    end
  end
  class IOManager < Array
    def initialize pm
      @pm = pm
      super()
    end
    def io
      main = map { |e| e.io }
      [main, @pm.plugin.each.map { |name, plug| plug[:io] }].flatten
    end
    def cb_by_io io
      cbs = []
      k = find { |e| e.io == io }
      if k
        cbs << k.cb if k
      else
        @pm.plugin.each do |name, plug|
          plug[:io].each { |pio| cbs << plug[:instance] if pio == io }
        end
      end
      cbs
    end
  end
end

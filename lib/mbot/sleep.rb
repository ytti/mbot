module MBot
  class Sleep
    def initialize
      @req = {}
    end
    def for requestor, sec=nil
      if not sec
        @req.delete requestor.to_sym
      else
        @req[requestor.to_sym] = sec.to_f
      end
    end
    def to_f
      f = @req.sort_by { |k,v| v }.first
      f ? f.last : CFG.sleep
    end
    alias_method :to_i, to_f
  end
end

module MBot
  class Sleep
    def initialize
      @req = {}
    end
    def for requestor, sec=nil
      if not sec
        @req.delete requestor.to_sym
      else
        @req[requestor.to_sym] = sec.to_i
      end
    end
    def to_i
      i = @req.sort_by { |k,v| v }.first
      i ? i.last : CFG.sleep
    end
  end
end

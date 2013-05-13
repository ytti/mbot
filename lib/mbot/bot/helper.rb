module MBot
  class Bot
    Colour = {
      :fg => {
        :white    => 0,
        :black    => 1,
        :blue     => 2,
        :green    => 3,
        :lred     => 4,
        :red      => 5,
        :purple   => 6,
        :magenta  => 6,
        :orange   => 7,
        :yellow   => 8,
        :lgreen   => 9,
        :cyan     => 10,
        :lcyan    => 11,
        :lblue    => 12,
        :lmagenta => 12,
        :gray     => 14,
        :lgray    => 15,
      },
      :bg => {
        :blgray   => 0,
        :black    => 1,
        :blue     => 2,
        :green    => 3,
        :bred     => 4,
        :red      => 5,
        :magenta  => 6,
        :orange   => 7,
        :borange  => 8,
        :bgreen   => 9,
        :cyan     => 10,
        :bcyan    => 11,
        :bblue    => 12,
        :bmagenta => 13,
        :bblack   => 14,
        :lgray    => 15,
      },
    } 
    def clr *args
      str = ''
      clr = false
      args.each do |arg|
        if arg.class == Symbol
          fg, bg = arg.to_s.downcase.split(/on/)
          fg = Colour[:fg][fg.to_sym]
          if bg
            bg = Colour[:bg][bg.to_sym] 
            bg = ',' + bg if bg
          end
          next unless fg
          str << "\003%s%s" % [fg, bg]
          clr = true
        else
          str << arg
          if clr
            str << "\003"
            clr = false
          end
        end
      end
      str
    end
  end
end

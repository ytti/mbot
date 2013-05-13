module MBot
  class User
    attr_accessor :nick, :user, :host
    def initialize nick, user=nil, host=nil
      nick, @host   = nick.split '@'
      nick, @user   = nick.split '!'
      @nick         = nick[1..-1] unless user
      @nick ||= nick
      @user ||= user
      @host ||= host
    end
    def to_s
      '%s!%s@%s' % [@nick, @user, @host]
    end
    def owner?
      '%s!%s@%s' % [CFG.owner[:nick], CFG.owner[:user], CFG.owner[:host]] == self.to_s
    end
    def == user
      self.to_s == user.to_s
    end
  end
end

module MBot
  class Bot
    ChannelMode = {
      :op    => 'o',
      :voice => 'v',
    }
    ChannelMode.each do |method, mode|
      define_method(method.to_s) do |nick=nil, channel=nil|
        channel_mode "+#{mode}", nick, channel
      end
      define_method("de#{method}") do |nick=nil, channel=nil|
        channel_mode "-#{mode}", nick, channel
      end
    end
  end
end

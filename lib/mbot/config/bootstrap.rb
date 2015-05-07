module MBot
  require 'fileutils'
  CFG.server = {
    :host => 'irc.tdc.fi',
    :port => 6667,
  }
  CFG.owner = {
    :nick => 'ytti',
    :user => 'ytti',
    :host => 'ytti.fi',
  }
  CFG.bot = {
    :nick => 'mbot42',
    :user => 'mbot',
    :name => 'mbot',
  }
  CFG.channel = [
    '&mbot1 withpw',
    '&mbot2',
  ]
  CFG.plugin = {
    :datadir => Config::PLUG_DATADIR,
    :dir     => Config::PLUG_DIR,
    :load => [
      'plug',
      'ping',
    ]
  }
  FileUtils.mkdir_p Config::ROOT
  FileUtils.mkdir_p Config::PLUG_DATADIR
  CFG.log = File.join Config::ROOT, 'log'
  CFG.sleep = nil
  CFG.save
end

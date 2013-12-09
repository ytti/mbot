#!/usr/bin/env ruby

require 'pry'
$VERBOSE = true
$: << File.join(ENV['HOME'], 'mbot', 'lib')
require 'mbot'

#exit if fork

def asapi
  irc = MBot.new ( {
    :server  => { :host => 'irc.tdc.fi' },
    :bot     => { :nick => 'xyzzy42' },
    :channel => %w( &mbot2 ),
    :plugin  => { 
       :datadir => MBot::Config::PLUG_DATADIR,
       :dir     => MBot::Config::PLUG_DIR,
       :load    => %w( plug ping ) },
  } )
  irc.msg 'testing testing', 'ytti'
  irc.loop
end

def main
  MBot.new.loop
end

begin
  main
rescue => e
  open (ENV['HOME'] + '/mbot.crash'), 'w' do |file|
    file.puts '-' * 50
    file.puts Time.now.utc
    file.puts e.message + ' [' + e.class.to_s + ']'
    file.puts '-' * 50
    file.puts e.backtrace
    file.puts '-' * 50
  end
end
#asapi

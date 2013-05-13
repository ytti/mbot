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

main
#asapi

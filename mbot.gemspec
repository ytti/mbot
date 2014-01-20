Gem::Specification.new do |s|
  s.name              = 'mbot'
  s.version           = '0.5.5'
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Saku Ytti' ]
  s.email             = %w( saku@ytti.fi )
  s.summary           = 'silly little irc bot'
  s.rubyforge_project = s.name
  s.files             = `git ls-files`.split("\n")
  s.require_path      = 'lib'
end

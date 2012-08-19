# -*- encoding: utf-8 -*-
require File.expand_path('../lib/toptracks/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jon Austin"]
  gem.email         = ["jon.i.austin@gmail.com"]
  gem.summary       = %q{Create m3u playlists of top artist tracks according to last.fm}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "toptracks"
  gem.require_paths = ["lib"]
  gem.version       = Toptracks::VERSION

  gem.add_development_dependency 'rspec', '~> 2.11.0'
  gem.add_development_dependency 'guard-rspec', '~> 1.2.1'
  gem.add_development_dependency 'guard-ctags-bundler', '~> 0.1.3'
  gem.add_development_dependency 'debugger', '~> 1.2.0'

  gem.add_dependency 'rockstar', '~> 0.6.4'
  gem.add_dependency 'ruby-mp3info', '~> 0.7.1'
  gem.add_dependency 'rainbow', '~> 1.1.4'
  gem.add_dependency 'ansi', '~> 1.4.3' # color logging
  gem.add_dependency 'm3uzi', '~> 0.5.1'
end

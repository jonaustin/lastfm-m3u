# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lastfm-m3u/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jon Austin"]
  gem.email         = ["jon.i.austin@gmail.com"]
  gem.summary       = %q{CLI tool to create m3u playlists of top artist tracks according to lastfm}
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/jonaustin/lastfm-m3u"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lastfm-m3u"
  gem.require_paths = ["lib"]
  gem.version       = LastfmM3u::VERSION

  gem.add_dependency 'rockstar',          '~> 0.8'
  gem.add_dependency 'ruby-mp3info',      '= 0.8.4' # 0.8.5 breaks reading id3v2 tags
  gem.add_dependency 'rainbow',           '~> 2.0'
  gem.add_dependency 'm3uzi',             '~> 0.5'
  gem.add_dependency 'highline',          '~> 1.6'
  gem.add_dependency 'ruby-progressbar',  '~> 1.7'
end

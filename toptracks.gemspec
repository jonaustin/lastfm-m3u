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
  gem.add_dependency 'rockstar', '~> 0.6.4'
  gem.add_dependency 'mp3info', '~> 0.6.18'
  gem.add_dependency 'mongoid', '~> 3.0.3'
  gem.add_dependency 'bson_ext', '~> 1.6.4'
end

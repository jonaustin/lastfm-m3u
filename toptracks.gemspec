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
end

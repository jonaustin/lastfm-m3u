require 'simplecov'
SimpleCov.start

# normal require does not work once gem is installed, because its loaded via rubygems
$:.unshift(File.expand_path('../lib', __FILE__))

require 'rspec'
require 'lastfm_m3u'

def music_dir
  File.expand_path("../support/fixtures/music/", __FILE__)
end

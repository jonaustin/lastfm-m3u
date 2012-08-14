#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'toptracks/version'

require 'rockstar'
require 'mp3info'
require 'rainbow'
require 'ansi/logger'


module Toptracks
  class Base
    def initialize
      @logger = ANSI::Logger.new(STDOUT)
      @rockstar = Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @m3u = File.new(File.join(File.dirname(__FILE__), '../../m3us/_LASTFM-TOP_-_' + @artist.name + '.m3u', 'w'))
    end
  end

  class Runner < Base
    def initialize
      super
    end
  end
end
require 'toptracks/models'
require 'toptracks/search'

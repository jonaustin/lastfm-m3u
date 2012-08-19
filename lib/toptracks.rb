#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'toptracks/version'

require 'rockstar'
require 'mp3info'
require 'm3uzi'
require 'rainbow'
require 'ansi/logger'

require 'toptracks/base'
require 'toptracks/search/files'

module Toptracks
  $logger = ANSI::Logger.new(STDOUT)
  $logger.level = 3 # errors only
end

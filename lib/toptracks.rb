#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'toptracks/version'

require 'rockstar'
require 'mp3info'
require 'rainbow'

require 'toptracks/models'
require 'toptracks/lastfm'
require 'toptracks/file'

module Toptracks
  DEBUG=0
  ECHO=0
end

#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'lastfm_m3u/version'

require 'rockstar'
require 'mp3info'
require 'm3uzi'
require 'rainbow'
require 'ansi/logger'

require 'lastfm_m3u/base'
require 'lastfm_m3u/lastfm'
require 'lastfm_m3u/search/file_search'

module LastfmM3u
  $logger = ANSI::Logger.new(STDOUT)
  $logger.level = 3 # errors only
  SEARCH_TYPES = [:file, :id3, :both]
end

#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'lastfm_tracks/version'

require 'rockstar'
require 'mp3info'
require 'm3uzi'
require 'rainbow'
require 'ansi/logger'

require 'lastfm_tracks/base'
require 'lastfm_tracks/lastfm'
require 'lastfm_tracks/search/file_search'

module LastfmTracks
  $logger = ANSI::Logger.new(STDOUT)
  $logger.level = 3 # errors only
  SEARCH_TYPES = [:file, :id3, :both]
end

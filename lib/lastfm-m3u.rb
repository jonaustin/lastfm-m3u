#require 'rbconfig' # lots of config info for current ruby install
require 'fileutils'
require 'pathname'
require 'lastfm-m3u/version'

require 'rockstar'
require 'm3uzi'
require 'rainbow/ext/string'

require 'lastfm-m3u/base'
require 'lastfm-m3u/lastfm'
require 'lastfm-m3u/search/file_search'
require 'lastfm-m3u/mp3_info_ext'

module LastfmM3u
  $logger = Logger.new(STDOUT)
  $logger.level = 3 # errors only
  SEARCH_TYPES = [:file, :id3, :both]
end

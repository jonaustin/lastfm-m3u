#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'ostruct'
require 'highline/import'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'toptracks'
require 'toptracks/util'

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Toptracks Playlist Creator"
  opts.define_head "Usage: toptracks [options]"
  opts.separator ""
  opts.separator "Examples:"
  #opts.separator "  toptracks # auto-search config-music_dir mp3 id3 tags for all unique artists, query last.fm for top tracks and create m3us for each artist from available track files"
  opts.separator "  toptracks -a Biosphere"
  opts.separator "  toptracks -a Biosphere -d ~/music/Biosphere"
  opts.separator "  toptracks -a Biosphere -o biosphere.m3u"
  opts.separator ""
  opts.separator ""
  opts.separator "Options:"

  # List of artists
  opts.on("-a x,y,z", Array, "list of artists") do |artists|
    options.artists = artists
  end

  # directory
  opts.on("-d DIR", "--directory DIR", "music directory") do |directory|
    options.directory = directory
  end

  opts.on('-o', '--output FILENAME', 'Write m3u to FILENAME') do |fn| # writes single m3u when multiple artists
    options.out_file = fn
  end

  opts.on('-p', '--path PATH', 'Specify path to use for m3u file entries (e.g. MPD requires a path relative to its music directory - i.e. -d /home/user/music/Biosphere -p /home/user/music where the second one is MPD\'s root)') do |path|
    options.path = Pathname path
  end

  opts.on('-l', '--limit NUM', 'Specify limit of tracks to fetch from Last.fm (defaults to all)') do |limit|
    options.limit = limit
  end

  opts.on('-f', '--force', 'Overwrite existing output file(s)') do
    options.force = true
  end

  opts.on('--debug [LEVEL]', 'Enable debugging output (Optional Level :: 0=all, 1=info,warn,error, 2=warn,error, 3=error)') do |level|
    if level
      options.debug = level.to_i
    else
      options.debug = 0
    end
  end

  opts.on_tail('-v', '--version', 'Show Toptracks version') do
    puts "Toptracks v#{Toptracks::VERSION}"
    exit
  end

  opts.on_tail('-h', '--help', 'Show this help message') do
    puts opts
    exit
  end
end.parse!

unless options.artists
  $logger.error "Please provide at least one artist (-a Elvis), see help for usage (-h)"
  exit
end

if options.debug
  $logger.level = options.debug
end

options.artists.each do |artist|
  not_found = []
  lastfm = Toptracks::Lastfm.new(artist)
  lastfm.root_dir = options.directory if options.directory
  lastfm.limit = options.limit.to_i if options.limit
  tracks = lastfm.artist.top_tracks

  lastfm.find_tracks(tracks).each do |track, track_set|
    if track_set.empty?
      not_found << track
      next
    end

    if track_set.size > 1
      track = Toptracks::Util.choose_track(track, track_set)
    else
      track = track_set.first
    end
    if options.path
      lastfm.m3u.add_file(track.relative_path_from options.path)
    else
      lastfm.m3u.add_file(track)
    end
  end
  lastfm.m3u.write(File.join(lastfm.m3u_path, "#{artist}.m3u"))

  unless not_found.empty?
    output_size = artist.length+10
    puts ("="*output_size).color(:blue)
    puts artist.center(output_size).color(:green)
    puts ("="*output_size).color(:blue)
    puts
    puts "Not Found:".color(:red)
    not_found.each {|track| puts "#{track}".color(:yellow) }
  end
end

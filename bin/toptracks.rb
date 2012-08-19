#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'ostruct'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'toptracks'

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
  opts.on("-d DIR", "directory") do |directory|
    options.dir = directory
  end

  opts.on('-o', '--output FILENAME', 'Write m3u to FILENAME') do |fn| # writes single m3u when multiple artists
    options.out_file = fn
  end

  opts.on('-p', '--path PATH', 'Specify path to use for m3u file entries (i.e. MPD requires a path relative to its music directory (and no leading slash))') do |path|
    options.path = Pathname path
  end

  opts.on('-f', '--force', 'Overwrite existing output file(s)') do
    options.force = true
  end

  opts.on('-d', '--debug [LEVEL]', 'Enable debugging output (Optional Level :: 0=all, 1=info,warn,error, 2=warn,error, 3=error)') do |level|
    puts level
    if level == true
      options.debug = 0
    else
      options.debug = level.to_i
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
  $logger.error "Please provide at least one artist (-a Elvis)"
  exit
end

if options.debug
  $logger.level = options.debug
  exit
end

options.artists.each do |artist|
  search = Toptracks::Search.new('/home/jon/music/trance')
  search.find(artist, :artist, :id3).each do |track|
      if options.path
        search.m3u.add_file(track.relative_path_from options.path)
      else
        search.m3u.add_file(track)
      end
    end
  search.m3u.write(File.join(search.m3u_path, "#{artist}.m3u"))

  #lfartist.fetch_tracks
  #puts lfartist.tracks[0].methods
  #lfartist.tracks.each { |t| puts "#{t.playcount} - #{t.name}" }
end

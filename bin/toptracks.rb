#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'ostruct'
require 'highline/import'
require 'ruby-progressbar'

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

  opts.on('-f', '--not-found', 'Show not found') do
    options.not_found = true
  end

  #opts.on('-f', '--force', 'Overwrite existing output file(s)') do
    #options.force = true
  #end

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

  puts
  progressbar = ProgressBar.create(starting_at: 0, total: tracks.size, format: "%a".color(:cyan) + "|".color(:magenta) + "%B".color(:green) + "|".color(:magenta) +  "%p%%".color(:cyan))
  lastfm.find_tracks(tracks, :file, progressbar).each do |track, track_set|
    if track_set.empty?
      not_found << track
      next
    end

    if track_set.size > 1
      unless found_track = Toptracks::Util.choose_track(track, track_set)
        not_found << track
        next
      end
      puts
    else
      found_track = track_set.first
    end
    if options.path
      lastfm.m3u.add_file(found_track.relative_path_from options.path)
    else
      lastfm.m3u.add_file(found_track)
    end
  end
  puts
  margin = 10
  output_size = artist.length+10
  puts " "*margin + ("="*output_size).color(:blue)
  puts artist.center(output_size+margin*2).color(:green)
  puts " "*margin + "#{tracks.size - not_found.size} tracks found".center(output_size).color(:green)
  puts " "*margin + ("="*output_size).color(:blue)

  lastfm.m3u.write(File.join(lastfm.m3u_path, "#{artist}.m3u"))

  unless not_found.empty? or options.not_found.nil?
    puts
    puts "Not Found:".color(:red)
    not_found.each {|track| puts "#{track}".color(:yellow) }
  end

end

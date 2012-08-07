#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'ostruct'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'toptracks'
require 'toptracks/version'

options = OpenStruct.new()
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

  opts.on('-f', '--force', 'Overwrite existing output file(s)') do
    options.force = true
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
  raise ArgumentError, "Please provide at least one artist (-a Elvis)"
end

options.artists.each do |artist|
  lfartist = Toptracks::Sources::Lastfm.new(artist)
  lfartist.fetch_tracks
  #puts lfartist.tracks[0].methods
  lfartist.tracks.each { |t| puts "#{t.playcount} - #{t.name}" }
end

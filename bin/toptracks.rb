#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'ostruct'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'toptracks'
require 'toptracks/version'

options = OpenStruct.new()
parser = OptionParser.new do |opts|
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

  opts.on('-o', '--output FILENAME', 'Write m3u to FILENAME (only with -a)') do |fn|
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

end
parser.parse!



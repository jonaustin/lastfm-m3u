module Toptracks
  class Base
    attr_accessor :artist, :m3u

    def initialize
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @artist = Rockstar::Artist
      @m3u = M3Uzi.new
    end
  end
end


module Toptracks
  class Lastfm

    attr_reader :artist, :tracks, :rockstar

    def initialize(artist)
      @rockstar = Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml')) #FIXME
      @artist = Rockstar::Artist.new(artist)
      @tracks = []
      @m3u = File.new(File.join(File.dirname(__FILE__), '../../m3us/_LASTFM-TOP_-_' + @artist.name + '.m3u', 'w'))
    end
  end
end

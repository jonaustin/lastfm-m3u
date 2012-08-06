module Toptracks
  module Sources
    attr_reader :artist, :tracks, 
    class Lastfm
      def initialize(artist)
        Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../lastfm.yml'))
        artist = Rockstar::Artist.new(artist)

      end
    end
  end
end

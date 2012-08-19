module Toptracks
  class Lastfm < Base
    attr_accessor :artist

    def initialize
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @artist = Rockstar::Artist
    end

  end
end

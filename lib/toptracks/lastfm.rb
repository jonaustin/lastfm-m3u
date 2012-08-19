module Toptracks
  class Lastfm < Base
    attr_accessor :artist, :root_dir

    def initialize(artist, root_dir='/home/jon/music/trance')
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @artist = Rockstar::Artist.new artist
      @root_dir = root_dir
      super()
    end

    def toptracks(search_type = :file)
      tracks = {}
      if search_type == :file
        search = Toptracks::FileSearch.new(root_dir)
      end
      @artist.top_tracks.each do |track|
        tracks[track.name] = search.find(track.name)
      end
      tracks
    end

  end
end

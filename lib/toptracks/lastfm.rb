module Toptracks
  class Lastfm < Base
    attr_accessor :artist, :root_dir, :limit

    def initialize(artist, root_dir='/home/jon/music/trance')
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @artist = Rockstar::Artist.new artist
      @root_dir = root_dir
      @limit = nil
      super()
    end

    def toptracks(search_type = :file)
      tracks = {}
      if search_type == :file
        search = Toptracks::FileSearch.new(root_dir)
      end
      top_tracks = @artist.top_tracks
      self.limit ||= top_tracks.size
      top_tracks[0..limit-1].each do |track|
        track.name = CGI.unescapeHTML(track.name)
        tracks[track.name] = search.find(track.name)
      end
      tracks
    end

  end
end

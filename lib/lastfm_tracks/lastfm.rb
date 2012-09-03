module LastfmTracks
  class Lastfm < Base
    attr_accessor :artist, :root_dir, :limit, :tracks

    def initialize(artist, root_dir='/home/jon/music/trance')
      Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @artist = Rockstar::Artist.new artist
      @root_dir = root_dir
      @limit = nil
      super()
    end

    def find_tracks(tracks, search_type = :file, progressbar = nil)
      begin
        raise InvalidSearchType unless SEARCH_TYPES.include?(search_type)
      rescue InvalidSearchType
        $logger.error("Invalid Search Type '#{search_type}', use one of #{SEARCH_TYPES.join(',')}")
        exit
      end
      found_tracks = {}
      search = LastfmTracks::FileSearch.new(root_dir)
      self.limit ||= tracks.size
      tracks[0..limit-1].each do |track|
        track.name = CGI.unescapeHTML(track.name)
        found_tracks[track.name] = search.find(track.name, {search_type: search_type})
        progressbar.increment if progressbar
      end
      found_tracks
    end

  end

  class InvalidSearchType < Exception; end
end

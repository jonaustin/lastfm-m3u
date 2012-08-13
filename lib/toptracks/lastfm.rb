module Toptracks
  class Lastfm

    attr_reader :artist, :tracks, :rockstar

    def initialize(artist)
      @rockstar = Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml')) #FIXME
      @artist = Rockstar::Artist.new(artist)
      @tracks = []
      @m3u = File.new(File.join(File.dirname(__FILE__), '../../m3us/_LASTFM-TOP_-_' + @artist.name + '.m3u', 'w'))
    end

    def fetch_tracks
      @artist.top_tracks.each do |track|
        @tracks << track
        next

        track.name = CGI.unescapeHTML(track.name)
        found_file = nil
        # loop through each mp3's id3 song tag to see if it matches
        # no: continue
        # match: add to m3u file

        # attempt to find via id3 tracks otherwise
        if found_file.nil? then
          puts track.name if DEBUG >= 2
          Dir["#{dir}/**/*.mp3"].each do |mp3|
            mp3_dir = File.dirname mp3
            id3 = Mp3Info.open(mp3)
            if id3.hastag2?
              if id3.tag2.TIT2.downcase == track.name.downcase
                found_file = id3.filename
              end
            elsif id3.hastag1?
              if id3.tag1.title.downcase == track.name.downcase
                found_file = id3.filename
              end
            end
          end
        end
        if found_file
          puts found_file if DEBUG >= 1
          puts found_file.sub!(PLAYLIST_ROOT_DIR, '') if ECHO >= 1
          @m3u << found_file.sub(PLAYLIST_ROOT_DIR, '') + "\n"
        else
          puts track.name + ' not found'
        end
      end

      @m3u.close

    end
  end
end

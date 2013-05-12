require 'fileutils'

module LastfmM3u
  class Lastfm < Base
    attr_accessor :artist, :root_dir, :limit, :tracks

    def initialize(artist, root_dir='/home/jon/music/trance')
      init_config
      set_artist(artist)
      set_top_tracks
      @root_dir = root_dir
      @limit = nil
      super()
    end

    def set_artist(artist)
      @artist = Rockstar::Artist.new artist
    end

    def set_top_tracks
      @tracks = @artist.top_tracks
    end

    def find_tracks(search_type = :file, progressbar = nil)
      begin
        raise InvalidSearchType unless SEARCH_TYPES.include?(search_type)
      rescue InvalidSearchType
        $logger.error("Invalid Search Type '#{search_type}', use one of #{SEARCH_TYPES.join(',')}")
        exit
      end
      found_tracks = {}
      search = LastfmM3u::FileSearch.new(root_dir)
      self.limit ||= tracks.size
      tracks[0..limit-1].each do |track|
        track.name = CGI.unescapeHTML(track.name)
        found_tracks[track.name] = search.find(track.name, {search_type: search_type})
        progressbar.increment if progressbar
      end
      found_tracks
    end


    private

    def init_config
      FileUtils.mkdir_p config_dir
      config_path = "#{config_dir}/lastfm-m3u.yml"
      unless File.exists? config_path
        puts "Copying empty config file to #{config_path}...".color(:green)
        FileUtils.cp(dist_config, config_path)
      end
      config_hash = YAML.load_file(config_path)
      if invalid_config?(config_hash)
        puts "Please add your api_key and api_secret to:\n  #{config_path}\nGet your keys at http://www.last.fm/api/account".color(:yellow)
        exit false
      else
        Rockstar.lastfm = config_hash
      end
    end

    def config_dir
      "#{ENV['HOME']}/.config"
    end

    def dist_config
      File.join(File.dirname(__FILE__), '../../config/lastfm-spotify.yml.dist')
    end

    def invalid_config?(config_hash)
      config_hash.values.any? {|v| v==''}
    end
  end

  class InvalidSearchType < Exception; end
end

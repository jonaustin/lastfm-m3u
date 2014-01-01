require 'fileutils'
require 'ruby-progressbar'

module LastfmM3u
  class Lastfm < Base
    attr_accessor :artist, :root_dir, :limit, :tracks

    def initialize(artist, options=OpenStruct.new)
      init_config
      set_artist(artist)
      set_top_tracks
      @root_dir = options.directory
      @limit = options.limit
      @search_type = options.type || :file
      super()
    end

    def set_artist(artist)
      @artist = Rockstar::Artist.new(artist)
    end

    def set_top_tracks
      @tracks = @artist.top_tracks
    end

    def find_tracks(search_type=@search_type, progressbar=false)
      check_for_invalid_search_type(search_type)
      found_tracks(tracks, search_type, progressbar)
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
      File.join(File.dirname(__FILE__), '../../config/lastfm.yml.dist')
    end

    def invalid_config?(config_hash)
      config_hash.values.any? {|v| v==''}
    end

    def search(search_type, track)
      case search_type
      when :file, :id3, :both
        LastfmM3u::FileSearch.new(root_dir).find(track.name, {search_type: search_type})
      end
    end

    def found_tracks(tracks, search_type, show_progressbar)
      self.limit ||= tracks.size
      progressbar = progressbar
      tracks[0..limit-1].each_with_object({}) do |track, found_tracks|
        track.name = CGI.unescapeHTML(track.name)
        found_tracks[track.name] = search(search_type, track)
        progressbar.increment if show_progressbar
      end
    end

    def check_for_invalid_search_type(search_type=@search_type)
      begin
        raise InvalidSearchType unless SEARCH_TYPES.include?(search_type)
      rescue InvalidSearchType
        $logger.error("Invalid Search Type '#{search_type}', use one of #{SEARCH_TYPES.join(',')}")
        exit
      end
    end
  end

  def progressbar
    ProgressBar.create(
      starting_at: 0,
      total: num_tracks,
      format: "%a".color(:cyan) + "|".color(:magenta) + "%B".color(:green) + "|".color(:magenta) +  "%p%%".color(:cyan))
  end

  class InvalidSearchType < Exception; end
end

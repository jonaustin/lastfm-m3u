module Toptracks
  class Base
    def initialize
      @logger = ANSI::Logger.new(STDOUT)
      @rockstar = Rockstar.lastfm = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/lastfm.yml'))
      @m3u = M3Uzi.new
    end
  end
end


module Toptracks
  class Base
    attr_accessor :m3u, :m3u_path

    def initialize
      @m3u_path = (File.expand_path(File.dirname(__FILE__) + "/../../m3u"))
      @m3u = M3Uzi.new
    end
  end
end


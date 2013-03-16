module LastfmM3u
  class Base
    attr_accessor :m3u, :m3u_path

    def initialize
      @m3u_path = Dir.pwd
      @m3u = M3Uzi.new
    end
  end
end


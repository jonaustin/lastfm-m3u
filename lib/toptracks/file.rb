module Toptracks
  require 'pathname'

  class File
    attr_accessor :root_dir, :track, :file

    def initialize(root_dir)
      @root_dir = Pathname root_dir
      @file = nil
    end

    def find(prefer_flac=true)
      # File find to see if any filename matches
      self.file = find_file('flac') if prefer_flac

      unless self.file
        self.file = find_file('mp3')
      end
    end

    def self.test
      t = self.new('/home/jon/music/trance')
      t.track = OpenStruct.new(name: 'Concrete Angel')
      t.find(false)
      t
    end

    private

    def find_file(ext)
      found_file = false
      Dir["#{root_dir}/**/*.#{ext}"].each do |file|
        file = Pathname file
        begin
          if file.basename.to_s =~ /.*#{Regexp.escape track.name}.*/i then
            found_file = file
            $log.info "#{track.name} => #{found_file}" if DEBUG >= 2
            break
          end
        rescue ArgumentError => e
          # for some reason it gets 'invalid byte sequence in UTF-8
          # even though replacing ascii below with utf-8 causes nothing to be replaced..wtf.
          file = Pathname file.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
          $log.warn "#{e.message} => #{file.relative_path_from(root_dir)}"
        end
      end
      found_file
    end

  end
end

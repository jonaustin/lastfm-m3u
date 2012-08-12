module Toptracks
  require 'pathname'

  class File
    attr_accessor :root_dir, :track, :file

    def initialize(root_dir)
      @root_dir = Pathname root_dir
    end

    def find(prefer_flac=true)
      # File find to see if any filename matches
      self.file = find_file('flac') if prefer_flac

      unless found_file
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
            puts "#{track.name} => #{found_file}".color(:green) #if DEBUG >= 2
            break
          end
        rescue ArgumentError => e
          # for some reason it gets 'invalid byte sequence in UTF-8
          # even though replacing ascii below with utf-8 causes nothing to be replaced..wtf.
          file = Pathname file.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
          puts "#{e.message} => #{file.relative_path_from(root_dir)}".color(:red)
        end
      end
      found_file
    end

  end
end

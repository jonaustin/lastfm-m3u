module Toptracks
  require 'pathname'

  class File
    attr_accessor :root_dir, :track

    def initialize(root_dir)
      @root_dir = Pathname root_dir
    end

    def find_by_track_name(prefer_flac=true)
      found_file = false
      # File find to see if any filename matches
      if prefer_flac
        Dir["#{root_dir}/**/*.flac"].each do |flac|
          flac = Pathname flac
          if flac.basename.to_s =~ /.*#{Regexp.escape track.name}.*/i then
            found_file = flac
            puts "#{track.name} => #{found_file}" #if DEBUG >= 2
            break
          end
        end
      end

      unless found_file
        Dir["#{root_dir}/**/*.mp3"].each do |mp3|
          mp3 = Pathname mp3
          begin
            if mp3.basename.to_s =~ /.*#{Regexp.escape track.name}.*/i then
              found_file = mp3
              puts "#{track.name} => #{found_file}".color(:green) #if DEBUG >= 2
              break
            end
          rescue ArgumentError => e
            # for some reason it gets 'invalid byte sequence in UTF-8
            # even though replacing ascii below with utf-8 causes nothing to be replaced..wtf.
            mp3 = Pathname mp3.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
            puts "#{e.message} => #{mp3.relative_path_from(root_dir)}".color(:red)
          end
        end
      end
      found_file
    end

    def self.test
      t = self.new('/home/jon/music/trance')
      t.track = OpenStruct.new(name: 'Concrete Angel')
      t.find_by_track_name(false)
      t
    end

  end
end

module Toptracks
  require 'pathname'

  class Search
    attr_accessor :root_dir, :track, :file, :m3u

    def initialize(root_dir, track)
      @root_dir = Pathname root_dir
      @track    = track # rockstar track
      @file     = nil
      @m3u      = []
    end

    def find(prefer_flac=true, type='both')
      if type == 'both' or type == 'file'
        # File find to see if any filename matches
        self.file = find_by_filename('flac') if prefer_flac
        self.file = find_by_filename('mp3') unless self.file
      end
    end

    def self.test
      track = OpenStruct.new(name: 'Concrete Angel')
      t = self.new('/home/jon/music/trance', track)
      t.find(false)
      t
    end

    protected

    def find_by_filename(ext)
      found_file = false
      Dir.glob("#{root_dir}/**/*.#{ext}").each do |file|
        begin
          file = Pathname.new file
          normalized_file = file.basename.sub('-', ' ').sub('_', ' ').sub(/#{file.extname}$/, '') # poor man's normalization
          if normalized_file.to_s =~ /.*#{Regexp.escape track.name}.*/i then
            found_file = file
            $logger.info "#{track.name} => #{found_file}" if DEBUG >= 2
            break
          end
        rescue ArgumentError => e
          # for some reason it gets 'invalid byte sequence in UTF-8
          # even though replacing ascii below with utf-8 causes nothing to be replaced..wtf.
          file = Pathname file.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
          $logger.warn "#{e.message} => #{file.relative_path_from(root_dir)}"
        end
      end
      found_file
    end

    def find_by_id3
      track.name = CGI.unescapeHTML(track.name)
      found_file = false
      # loop through each mp3's id3 song tag to see if it matches
      # no: continue
      # match: add to m3u file

      $logger.info track.name if DEBUG >= 2
      Dir.glob("#{root_dir}/**/*.(mp3").each do |mp3|
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
      found_file
    end
  end
end

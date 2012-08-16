module Toptracks
  require 'pathname'
  require 'toptracks'

  class Search < Base
    attr_accessor :root_dir

    def initialize(root_dir)
      @root_dir = Pathname root_dir
      super()
    end

    def find(query, query_type=:track, file_or_id3=:both, prefer_flac=true)
      if file_or_id3 == :both or file_or_id3 == :file
        file = find_by_filename(query, query_type, :flac) if prefer_flac
        file = find_by_filename(query, query_type, :mp3) unless file
      elsif file_or_id3 == :both or file_or_id3 == :id3
        file = find_by_id3(query, query_type)
      end
      file
    end

    def self.test
      track = OpenStruct.new(name: 'Concrete Angel')
      t = self.new('/home/jon/music/trance', track)
      t.find(false)
      t
    end

    def find_by_filename(name, query_type, ext)
      found_file = false
      Dir.glob("#{root_dir}/**/*.#{ext.to_s}").each do |file|
        begin
          file = Pathname.new file
          if query_type == :artist or query_type == :album
            if file.directory? and normalize(file).to_s =~ /.*#{Regexp.escape name}.*/i
              found_file = file
              break
            end
          else
            if normalize(file).to_s =~ /.*#{Regexp.escape name}.*/i
              found_file = file
              @logger.debug "#{name} => #{found_file}"
              break
            end
          end
        rescue ArgumentError => e
          # for some reason it gets 'invalid byte sequence in UTF-8
          # even though replacing ascii below with utf-8 causes nothing to be replaced..wtf.
          file = Pathname file.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
          @logger.warn "#{e.message} => #{file.relative_path_from(root_dir)}"
        end
      end
      found_file
    end

    def find_by_id3(query, query_type)
      query = CGI.unescapeHTML(query)
      found_file = false
      @logger.info query
      Dir.glob("#{root_dir}/**/*.mp3").each do |file|
        file = Pathname.new file
        begin
          id3 = Mp3Info.open(file)
          if id3.hastag2? and id3.tag2.TIT2.downcase == query.downcase
            found_file = id3.filename
          elsif id3.hastag1? and id3.tag1.title.downcase == query.downcase
            found_file = id3.filename
          end
        rescue Mp3InfoError => e
          @logger.warn "#{e.message} => #{file.relative_path_from(root_dir)}"
        end
      end
      found_file
    end

    def normalize(pathname)
      pathname.basename.sub('-', ' ').sub('_', ' ').sub(/#{pathname.extname}$/, '') # poor man's normalization
    end
  end

end

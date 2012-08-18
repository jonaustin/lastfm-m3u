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
      files = []
      if file_or_id3 == :both or file_or_id3 == :file
        files = find_in_filesystem(query, query_type, :flac) if prefer_flac
        files = find_in_filesystem(query, query_type, :mp3)  if files.empty?
      end
      if file_or_id3 == :both or file_or_id3 == :id3
        files = find_by_id3(query, query_type)
      end
      $logger.debug "#{query} => #{files}"
      files
    end

    def find_in_filesystem(name, query_type, ext)
      if query_type == :artist or query_type == :album
        find_by_dir(name)
      else
        find_by_filename(name, ext)
      end
    end

    def find_by_dir(name)
      found_entries = []
      Dir.glob("#{root_dir}/**/*").each do |entry|
        entry = Pathname.new entry
        found_entries << entry if entry.directory? and normalize(entry).to_s =~ /.*#{Regexp.escape name}.*/i
      end
      found_entries
    end

    def find_by_filename(name, ext)
      found_entries = []
      Dir.glob("#{root_dir}/**/*.#{ext.to_s}").each do |entry|
        begin
          entry = Pathname.new entry
          if normalize(entry).to_s =~ /.*#{Regexp.escape name}.*/i
            $logger.debug "#{name} => #{entry}"
            found_entries << entry
          end
        rescue ArgumentError => e
          # for some reason it gets 'invalid byte sequence in UTF-8
          # even though replacing ascii below with utf-8 causes nothing to be replaced.
          entry = Pathname entry.to_s.encode('ascii', invalid: :replace, undef: :replace, replace: '??')
          $logger.warn "#{e.message} => #{entry.relative_path_from(root_dir)}"
        end
      end
      found_entries
    end

    def find_by_id3(query, query_type)
      query = CGI.unescapeHTML(query)
      found_entries = []
      $logger.debug query
      Dir.glob("#{root_dir}/**/*.mp3").each do |entry|
        entry = Pathname.new entry
        begin
          id3 = false
          Kernel.silence_warnings do # quiet ruby-mp3info's 'tag not full parsed' warnings
            id3 = Mp3Info.open(entry)
          end
          if query_type == :track
            if id3.hastag2? and id3.tag2.TIT2.downcase == query.downcase
              found_entries << id3.filename
            elsif id3.hastag1? and id3.tag1.title.downcase == query.downcase
              found_entries << id3.filename
            end
          elsif query_type == :album
            if id3.hastag2? and id3.tag2.TALB.downcase == query.downcase
              found_entries << id3.filename
            elsif id3.hastag1? and id3.tag1.album.downcase == query.downcase
              found_entries << id3.filename
            end
          elsif query_type == :artist
            if id3.hastag2? and id3.tag2.TPE1.downcase == query.downcase
              found_entries << id3.filename
            elsif id3.hastag1? and id3.tag1.artist.downcase == query.downcase
              found_entries << id3.filename
            end
          end
        rescue Mp3InfoError => e
          $logger.warn "#{e.message} => #{entry.relative_path_from(root_dir)}"
        rescue NoMethodError => e
          $logger.warn "No tags found => #{entry.relative_path_from(root_dir)}"
        end
      end
      found_entries
    end

    def normalize(pathname)
      pathname.basename.sub('-', ' ').sub('_', ' ').sub(/#{pathname.extname}$/, '')
    end
  end

end

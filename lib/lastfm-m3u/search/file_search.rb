module LastfmM3u
  require 'lastfm-m3u'
  require 'pathname'

  class Search < Base
  end

  class FileSearch < Search
    attr_accessor :root_dir

    def initialize(root_dir)
      @root_dir = Pathname root_dir
      super()
    end

    def find(query, options={})
      query_type  = options[:query_type] || :track
      file_or_id3 = options[:search_type] || :both
      prefer_flac = options[:prefer_flac] || true

      files = find_unique_files(query, query_type, file_or_id3)
      if prefer_flac && !(flac_files=trim_non_flac(files)).empty?
        files = flac_files
      end
      $logger.debug "#{query} => #{files}"
      files
    end


    private

    def find_unique_files(query, query_type, file_or_id3)
      files = id3_files = []
      files = find_in_filesystem(query, query_type) if [:both, :file].include? file_or_id3
      id3_files = find_by_id3(query, query_type) if [:both, :id3].include? file_or_id3
      (files + id3_files).sort.uniq
    end

    def find_in_filesystem(name, query_type)
      if query_type == :artist or query_type == :album
        find_by_dir(name)
      else
        find_by_filename(name)
      end
    end

    def find_by_dir(name)
      found_entries = []
      Dir.glob("#{root_dir}/**/*").each do |entry|
        entry = Pathname.new entry
        found_entries << entry.to_s if entry.directory? and normalize(entry).to_s =~ /.*#{Regexp.escape name}.*/i
      end
      found_entries
    end

    def find_by_filename(name)
      found_entries = []
      Dir.glob("#{root_dir}/**/*.{mp3,flac}").each do |entry|
        begin
          entry = Pathname.new entry
          if normalize(entry) =~ /.*#{Regexp.escape name}.*/i
            $logger.debug "#{name} => #{entry}"
            found_entries << entry.to_s
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
        begin
          id3 = Mp3InfoExt.new(query, query_type, entry)
          found_entries << id3.filename if id3.found?
        rescue Mp3InfoError => e
          $logger.warn "#{e.message} => #{(Pathname.new entry).relative_path_from(root_dir)}"
        rescue NoMethodError => e
          $logger.warn "No tags found => #{(Pathname.new entry).relative_path_from(root_dir)}"
        end
      end
      found_entries
    end

    def normalize(pathname)
      pathname.basename.to_s.gsub('-', ' ').gsub('_', ' ').sub(/#{pathname.extname}$/, '')
    end

    def trim_non_flac(pathnames)
      pathnames.select{|pn| pn.to_s =~ /\.flac$/}
    end
  end

end

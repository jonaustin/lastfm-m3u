module LastfmTracks

  class MongoSearch < Search
    def initialize
    end

    #def find(query, query_type=:track, file_or_id3=:both, prefer_flac=true)
      #files = id3_files = []
      #if file_or_id3 == :both or file_or_id3 == :file
        #files = LastfmToptracks::Track.where(filename: 
      #end
      #if file_or_id3 == :both or file_or_id3 == :id3
        #id3_files = find_by_id3(query, query_type)
      #end
      #files = (files + id3_files).sort.uniq
      #if prefer_flac and ((flac_files = trim_non_flac(files)) != [])
        #files = flac_files
      #end
      #$logger.debug "#{query} => #{files}"
      #files
    #end
  end
end

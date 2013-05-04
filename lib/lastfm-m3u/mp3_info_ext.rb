require 'mp3info'

class Mp3InfoExt < Mp3Info
  attr_reader :query, :query_type

  def initialize(query, query_type, entry)
    @query = query
    @query_type = query_type
    super(entry)
  end

  def found?
    return true if @query_type == :track && title_found?
    return true if @query_type == :album && album_found?
    return true if @query_type == :artist && artist_found?
    return false
  end

  # ARTIST
  def artist_found?
    tag2_artist_found? || tag1_artist_found?
  end

  def tag2_artist_found?
    hastag2? && tag2.TPE1.downcase == query.downcase
  end

  def tag1_artist_found?
    hastag1? && tag1.artist.downcase == query.downcase
  end

  # ALBUM
  def album_found?
    tag2_album_found? || tag1_album_found?
  end

  def tag2_album_found?
    hastag2? && tag2.TALB.downcase == query.downcase
  end

  def tag1_album_found?
    hastag1? && tag1.album.downcase == query.downcase
  end

  # TITLE
  def title_found?
    tag2_title_found? || tag1_title_found?
  end

  def tag2_title_found?
    hastag2? && tag2.TIT2.downcase == query.downcase
  end

  def tag1_title_found?
    hastag1? and tag1.title.downcase == query.downcase
  end
end

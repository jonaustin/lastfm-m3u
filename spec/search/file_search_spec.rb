require 'spec_helper'

describe LastfmM3u::FileSearch do
  before { Logger.any_instance.stub(:warn => false, :info => false, :debug => false) } # quiet logging

  let(:file_search) { LastfmM3u::FileSearch.new(music_dir) }

  context "root dir" do
    it "should set the root dir" do
      file_search.root_dir.to_s.should == music_dir
    end

    it "should be a pathname" do
      file_search.root_dir.class.should == Pathname
    end
  end

  context "normalization" do
    it "should find a filename with underscores in place of spaces" do
      file_search.find('my way', {search_type: :file}).first.to_s.should match /my_way/
    end

    it "should find a file with dashes in place of spaces" do
      file_search.find('poa alpina', {search_type: :file}).to_s.should match /poa-alpina/
    end
  end

  context "find by filename" do
    it "should be an array" do
      file_search.find('my way').should be_an_instance_of(Array)
    end

    it "should return a filename" do
      filename = file_search.find('stepping_stone')
      (Pathname.new music_dir).join('sid_vicious/05._stepping_stone.mp3').should exist
    end

    it "should continue when bad filename" do
      path = "spec/support/fixtures/music/11\ Tchaikovsky\ -\ S$'\351'r$'\351'nade\ m$'\351'lancoliq.mp3".force_encoding('utf-8')
      Dir.stub_chain(:glob).and_return [path]
      expect { file_search.find('tchaikovsky', {search_type: :file, prefer_flac: false}) }.to raise_error ArgumentError
    end

    context "track" do
      it "should find a track if one exists" do
        file_search.find('stepping stone', {search_type: :file}).to_s.should match /stepping_stone/
      end

      it "should find flac" do
        file_search.find('flac song', {search_type: :file}).to_s.should match /flac_song/
      end
    end

    context "prefer flac" do
      it "should only return flac files if any found" do
        file_search.find('flac song', {search_type: :file}).to_s.should match /flac_song.flac/
      end

    context "artist or album" do
      it "should find an artist or album directory" do
        file_search.find('biosphere', {query_type: :artist, search_type: :file}).to_s.should match /biosphere/
      end
    end
    end
  end

  context "find by id3" do
    it "should return an array" do
      file_search.find('id3v1-title', {search_type: :id3}).should be_an_instance_of(Array)
    end

    it "should return filename" do
      file_search.find('id3v1-title', {search_type: :id3}).first.should == "#{music_dir}/id3v1.mp3"
    end

    context "track" do
      it "should find a tag" do
        file_search.find('id3v1-title', {search_type: :id3}).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-title', {search_type: :id3}).first.to_s.should match /id3v2/i
      end
    end

    context "album" do
      it "should find a tag" do
        file_search.find('id3v1-album', {query_type: :album, search_type: :id3}).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-album', {query_type: :album, search_type: :id3}).first.to_s.should match /id3v2/i
      end
    end

    context "artist" do
      it "should find a tag" do
        file_search.find('id3v1-artist', {query_type: :artist, search_type: :id3}).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-artist', {query_type: :artist, search_type: :id3}).first.to_s.should match /id3v2/i
      end
    end

  end

end

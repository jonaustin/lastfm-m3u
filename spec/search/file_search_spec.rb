require 'spec_helper'

describe LastfmTracks::FileSearch do
  before { ANSI::Logger.any_instance.stub(:warn => false, :info => false, :debug => false) } # quiet logging

  let(:music_dir) { File.expand_path("../../support/fixtures/music", __FILE__) }
  let(:file_search) { LastfmTracks::FileSearch.new(music_dir) }

  context "root dir" do
    it "should set the root dir" do
      file_search.root_dir.to_s.should == music_dir
    end

    it "should be a pathname" do
      file_search.root_dir.class.should == Pathname
    end
  end

  context "find" do
    pending
  end

  context "normalization" do
    it "should find a filename with underscores in place of spaces" do
      file_search.find('my way', :track, :file).first.to_s.should match /my_way/
    end

    it "should find a file with dashes in place of spaces" do
      file_search.find('poa alpina', :track, :file).to_s.should match /poa-alpina/
    end
  end

  context "find by filename" do
    it "should be an array" do
      file_search.find('my way').should be_an_instance_of(Array)
    end

    it "should return an Pathnames" do
      file_search.find('stepping stone').first.should be_an_instance_of(Pathname)
    end

    it "should continue when bad filename" do
      path = "spec/support/fixtures/music/11\ Tchaikovsky\ -\ S$'\351'r$'\351'nade\ m$'\351'lancoliq.mp3".force_encoding('utf-8')
      Dir.stub_chain(:glob).and_return [path]
      expect { file_search.find('tchaikovsky', :track, :file, false) }.to raise_error ArgumentError
    end

    context "track" do
      it "should find a track if one exists" do
        file_search.find('stepping stone', :track, :file).to_s.should match /stepping stone/
      end
      it "should find flac" do
        file_search.find('flac song', :track, :file, true).to_s.should match /flac song/
      end
    end

    context "artist or album" do
      it "should find an artist or album directory" do
        file_search.find('biosphere', :artist, :file).to_s.should match /biosphere/
      end
    end

    context "prefer flac" do
      it "should only return flac files if any found" do
        pending
      end
    end
  end

  context "find by id3" do
    it "should return an array" do
      file_search.find('id3v1-title', :track, :id3).should be_an_instance_of(Array)
    end

    it "should return Pathnames" do
      file_search.find('id3v1-title', :track, :id3).first.should be_an_instance_of(Pathname)
    end

    context "track" do
      it "should find a tag" do
        file_search.find('id3v1-title', :track, :id3).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-title', :track, :id3).first.to_s.should match /id3v2/i
      end
    end

    context "album" do
      it "should find a tag" do
        file_search.find('id3v1-album', :album, :id3).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-album', :album, :id3).first.to_s.should match /id3v2/i
      end
    end

    context "artist" do
      it "should find a tag" do
        file_search.find('id3v1-artist', :artist, :id3).first.to_s.should match /id3v1/i
      end

      it "should find a id3v2 tag" do
        file_search.find('id3v2-artist', :artist, :id3).first.to_s.should match /id3v2/i
      end
    end

  end

end

require 'spec_helper'
require 'ostruct'

describe Toptracks::Search do
  before { ANSI::Logger.any_instance.stub(:warn => false, :info => false, :debug => false) } # quiet logging

  let(:music_dir) { File.expand_path("../support/fixtures/music", __FILE__) }
  let(:search) { Toptracks::Search.new(music_dir) }

  context "root dir" do
    it "should set the root dir" do
      search.root_dir.to_s.should == music_dir
    end

    it "should be a pathname" do
      search.root_dir.class.should == Pathname
    end
  end

  context "find" do
    pending
  end

  context "find by filename" do
    it "should find a file if one exists" do
      search.find('stepping stone', 'file').to_s.should match /stepping stone/
    end

    context "normalization" do
      it "should find a filename with underscores in place of spaces" do
        search.find('my way', 'file').to_s.should match /my_way/
      end

      it "should find a file with dashes in place of spaces" do
        search.find('poa alpina', 'file').to_s.should match /poa-alpina/
      end

      it "should continue when bad filename" do
        path = "spec/fixtures/music/11\ Tchaikovsky\ -\ S$'\351'r$'\351'nade\ m$'\351'lancoliq.mp3".force_encoding('utf-8')
        Dir.stub_chain(:glob).and_return [path]
        expect { search.find('tchaikovsky', 'file', false) }.to raise_error ArgumentError
      end

      context "prefer flac" do
        it "should find flac" do
          search.find('flac song', 'file', true).to_s.should match /flac song/
        end

        it "should search twice if no flac found" do
          search.should_receive(:find_by_filename).twice
          search.find('my way', 'file', true)
        end
      end
    end
  end

  context "find by id3" do
    it "should find a tag" do
      search.find('id3v1', 'id3').to_s.should match /id3v1/i
    end

    it "should find a id3v2 tag" do
      search.find('id3v2', 'id3').to_s.should match /id3v2/i
    end
  end

end

require 'spec_helper'
require 'ostruct'

describe Toptracks::Search do
  let(:music_dir) { File.expand_path('../fixtures/music', __FILE__) }
  let(:track) { OpenStruct.new(name: 'stepping stone') }
  let(:search) { Toptracks::Search.new(music_dir, track) }

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
      search.find(false, 'file')
      search.file.to_s.should match /stepping stone/
    end

    context "normalization" do
      it "should find a filename with underscores in place of spaces" do
        search.track = OpenStruct.new(name: 'my way')
        search.find(false, 'file')
        search.file.to_s.should match /my_way/
      end

      it "should find a file with dashes in place of spaces" do
        search.track = OpenStruct.new(name: 'poa alpina')
        search.find(false, 'file')
        search.file.to_s.should match /poa-alpina/
      end

      it "should continue when bad filename" do
        path = "spec/fixtures/music/11\ Tchaikovsky\ -\ S$'\351'r$'\351'nade\ m$'\351'lancoliq.mp3".force_encoding('utf-8')
        Dir.stub_chain(:glob).and_return [path]
        expect { search.find(false) }.to raise_error ArgumentError
      end

      context "prefer flac" do
        it "should find flac" do
          search.track.name = 'flac song'
          search.find(true, 'file')
          search.file.to_s.should match /flac song/
        end

        it "should search twice if no flac found" do
          search.track.name = 'my way'
          search.should_receive(:find_by_filename).twice
          search.find(true, 'file')
        end
      end
    end
  end

  context "find by id3" do
    it "should find a tag" do
      search.find(false, 'id3v1')
      search.file.to_s.should match /mp3 with id3/
    end

    it "should find a id3v2 tag" do
      search.find(false, 'id3')
      search.file.to_s.should match /mp3 with id3v2/
    end
  end

end

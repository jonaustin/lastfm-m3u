require 'spec_helper'
require 'ostruct'

describe Toptracks::Search do
  let(:music_dir) { File.expand_path('../fixtures/music', __FILE__) }
  let(:track) { OpenStruct.new(name: 'my way') }
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
    it "should find a file if one exists" do
      search.find(false)
      search.file.to_s.should match /my_way.mp3/
    end
  end
end


require 'spec_helper'
require 'ostruct'

describe Toptracks::File do
  let(:music_dir) { File.expand_path('../fixtures/music', __FILE__) }
  let(:track) { OpenStruct.new(name: 'my way') }
  let(:file) { Toptracks::File.new(music_dir, track) }

  context "root dir" do
    it "should set the root dir" do
      file.root_dir.to_s.should == music_dir
    end

    it "should be a pathname" do
      puts music_dir.to_s
      file.root_dir.class.should == Pathname
    end
  end

  context "find" do
    it "should find a file if one exists" do
      file.find(false)
      file.file.to_s.should match /my_way.mp3/
    end
  end
end


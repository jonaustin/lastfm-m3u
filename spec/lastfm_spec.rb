require 'spec_helper'
require 'ostruct'

describe Toptracks::Lastfm do
  context "find_tracks" do
    it "should call Filesearch.find" do
      track = OpenStruct.new(name: 'track')
      search = double()
      search.stub(:find)
      Toptracks::FileSearch.stub(:new).and_return search
      search.should_receive(:find).once
      lf = Toptracks::Lastfm.new('artist', '/')
      lf.find_tracks([track])
    end
  end

end

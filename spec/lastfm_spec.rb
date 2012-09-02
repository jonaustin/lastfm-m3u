require 'spec_helper'
require 'ostruct'

describe LastfmTracks::Lastfm do
  it "should return expected results" do
    track = OpenStruct.new(name: 'Poa Alpina')
    lf = LastfmTracks::Lastfm.new('Biosphere', music_dir)
    found = lf.find_tracks([track])
    found.should == { track.name => ["#{music_dir}/biosphere/poa-alpina.mp3"] }
  end
end

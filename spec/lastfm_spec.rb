require 'spec_helper'
require 'ostruct'

describe LastfmM3u::Lastfm do
  it "should return expected results" do
    YAML.stub(:load_file).and_return({api_key: 'key', api_secret: 'secret'})
    track = OpenStruct.new(name: 'Poa Alpina')
    lf = LastfmM3u::Lastfm.new('Biosphere', music_dir)
    found = lf.find_tracks([track])
    found.should == { track.name => ["#{music_dir}/biosphere/poa-alpina.mp3"] }
  end
end

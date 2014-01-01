require 'spec_helper'
require 'ostruct'

describe LastfmM3u::Lastfm do
  let(:options) { OpenStruct.new(directory: music_dir, search_type: :file) }

  it "should successfully run full circle" do
    YAML.stub(:load_file).and_return({api_key: 'key', api_secret: 'secret'})
    track = OpenStruct.new(name: 'Poa Alpina')
    lf = LastfmM3u::Lastfm.new('Biosphere', options)
    lf.send(:tracks=, [track])
    found = lf.find_tracks
    found.should == { track.name => ["#{music_dir}/biosphere/poa-alpina.mp3"] }
  end
end

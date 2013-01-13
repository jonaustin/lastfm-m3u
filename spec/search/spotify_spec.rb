require 'spec_helper'

describe LastfmTracks::Search::Spotify do
  before { ANSI::Logger.any_instance.stub(:warn => false, :info => false, :debug => false) } # quiet logging



end

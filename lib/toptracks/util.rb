module Toptracks
  module Util
    def self.choose_track(track, track_set)
      choose do |menu|
        menu.index        = :letter
        menu.index_suffix = ") "

        menu.prompt = "For #{track}, which file would you like to use?   ".color(:green)

        track_set.each do |track|
          menu.choice track do
            return track
          end
        end
      end
    end
  end
end

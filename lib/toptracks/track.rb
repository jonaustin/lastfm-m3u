module Toptracks
  class Track
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :artist, type: String
    field :album, type: String
    #field :playcount_global, type: Integer
    #field :playcount_mine, type: Integer
    #field :order, type: Integer
  end
end

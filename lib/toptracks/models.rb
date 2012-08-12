module Toptracks
  require "mongoid"

  Mongoid.configure do |config|
    ENV["MONGOID_ENV"] ||= 'development'
    file_name = File.join(File.dirname(__FILE__), "..", "..", "config", "mongoid.yml")
    config.load!(file_name)
  end

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

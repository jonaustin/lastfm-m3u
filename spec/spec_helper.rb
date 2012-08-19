require 'simplecov'
SimpleCov.start

# normal require does not work once gem is installed, because its loaded via rubygems
$:.unshift(File.expand_path('../lib', __FILE__))

require 'rspec'
require 'toptracks'

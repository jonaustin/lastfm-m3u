#!/usr/bin/env rake
require 'rubygems'
require "bundler/setup"
require "bundler/gem_tasks"

# RSpec
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end
task :default => :spec

notification :terminal_notifier

guard 'rspec', :version => 2, :all_after_pass => false, :all_on_start => false, :cli => "--color --format nested --fail-fast" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/lastfm_m3u/(.+)\.rb$})             { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'ctags-bundler', :src_path => ["lib", "spec/support"] do
  watch(/^(lib|spec\/support)\/.*\.rb$/)
  watch('Gemfile.lock')
end

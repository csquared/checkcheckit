require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.ruby_opts << '-I lib'
  t.ruby_opts << '-I test'
  t.ruby_opts << '-r turn/autorun'
end

task(default: :test)

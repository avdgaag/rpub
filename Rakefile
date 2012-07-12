require 'bundler'
Bundler::GemHelper.install_tasks
Bundler.setup


desc 'Default: run specs.'
task :default => [:spec, :cucumber]

require 'rspec/core/rake_task'
desc 'Run specs'
RSpec::Core::RakeTask.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = '--format progress --tags ~@epubcheck'
end

require "bundler/gem_tasks"

begin
  require 'cucumber/rake/task'
rescue LoadError
  $stderr.puts "Cucumber not installed, please run"
  $stderr.puts "$ gem install cucumber"
  exit 1
end

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
end

task :default => :cucumber

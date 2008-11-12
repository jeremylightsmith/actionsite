$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'action_site'
require 'spec/rake/spectask'

task :default => [:spec, :example]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "generate the example site"
task :example do
  Dir.chdir(File.dirname(__FILE__)) do
    ActionSite::Site.new("example/src", "example/public").generate
  end
end
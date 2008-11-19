$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/lib")

require 'action_site'
require 'spec/rake/spectask'

task :default => [:spec, :gemspec, :example]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "generate the example site"
task :example do
  ActionSite::Site.new("example/src", "example/public").generate
end

desc "generate gemspec"
task :gemspec do
  File.open("actionsite.gemspec", "w") do |f| 
    f << ERB.new(File.read("actionsite.gemspec.erb"), 0, "%<>").result(binding)
  end  
end


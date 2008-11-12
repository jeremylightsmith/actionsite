$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib")
require "action_site"

gem 'rspec'
require 'spec'

gem 'file_sandbox', '>= 0.4'
require 'file_sandbox_behavior'

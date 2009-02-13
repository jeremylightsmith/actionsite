require 'rubygems'

gem 'activesupport'
require 'active_support'

gem 'RedCloth'
require 'redcloth'

gem 'markaby'
require 'markaby'

require 'erb'
require 'yaml'

require 'action_site/extensions/string'

require 'action_site/site'
require 'action_site/link_checker'

module ActionSite
  VERSION = 0.3
end
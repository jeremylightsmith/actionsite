Gem::Specification.new do |s|
  s.name     = "actionsite"
  s.version  = "0.4"
  s.date     = "2008-11-12"
  s.summary  = "A static site generator patterned after rails view templates supporting erb, yaml, redcloth and markaby(ish)"
  s.email    = "jeremy.lightsmith@gmail.com"
  s.homepage = "http://github.com/jeremylightsmith/actionsite"
  s.description = "ActionSite is a static site generator for ruby patterned after rails view templates supporting erb, yaml, redcloth and markaby(ish)."
  s.has_rdoc = false
  s.authors  = ["Jeremy Lightsmith"]
  s.files    = ["Rakefile", "readme.txt", "lib/action_site", "lib/action_site/async_link_checker.rb", "lib/action_site/context.rb", "lib/action_site/extensions", "lib/action_site/extensions/string.rb", "lib/action_site/generators", "lib/action_site/generators/erb_generator.rb", "lib/action_site/generators/markaby_generator.rb", "lib/action_site/generators/redcloth_generator.rb", "lib/action_site/generators/yaml_generator.rb", "lib/action_site/helpers", "lib/action_site/helpers/form_helper.rb", "lib/action_site/helpers/markaby_helper.rb", "lib/action_site/helpers/url_helper.rb", "lib/action_site/html_generator.rb", "lib/action_site/link_checker.rb", "lib/action_site/page_context.rb", "lib/action_site/site.rb", "lib/action_site.rb", "example/src/helpers", "example/src/helpers/blues_hero_helper.rb", "example/src/images", "example/src/images/batjeremy.jpg", "example/src/images/black_header.png", "example/src/images/black_header_with_slogan.png", "example/src/images/chris.jpg", "example/src/images/hawk-karissa.png", "example/src/images/header.png", "example/src/images/jeremy.jpg", "example/src/images/jocelyn.jpg", "example/src/images/karen.jpg", "example/src/images/karissa.jpg", "example/src/images/kevin.jpg", "example/src/images/lessa.jpg", "example/src/images/lucy.jpg", "example/src/images/menu_bar.png", "example/src/images/simple_header.png", "example/src/images/solomon.jpg", "example/src/images/supertopher.jpg", "example/src/images/supertopher_and_batjeremy.jpg", "example/src/images/teacher_contact_sheet.jpg", "example/src/images/topher.jpg", "example/src/index.html.erb", "example/src/layouts", "example/src/layouts/application.html.erb", "example/src/register.html.erb", "example/src/schedule.html.erb", "example/src/stylesheets", "example/src/stylesheets/application.css", "example/src/teachers.html.erb"]
  s.test_files = ["spec/action_site", "spec/action_site/context_spec.rb", "spec/action_site/extensions", "spec/action_site/extensions/string_spec.rb", "spec/action_site/helpers", "spec/action_site/helpers/form_helper_spec.rb", "spec/action_site/helpers/url_helper_spec.rb", "spec/action_site/html_generator_spec.rb", "spec/action_site/link_checker_spec.rb", "spec/action_site/page_context_spec.rb", "spec/spec_helper.rb"]
  
  s.add_dependency("activesupport", ["> 0.0.0"])
  s.add_dependency("RedCloth", ["> 0.0.0"])
  s.add_dependency("markaby", ["> 0.0.0"])
  s.add_dependency("thin", [">= 1.0.0"])
end

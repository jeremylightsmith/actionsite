module ActionSite
  module Generators
    class YamlGenerator
      def process(context, content)
        content = YAML::load(content) rescue raise("error reading #{context.file_name}: #{$!.message}")
      end
    end
  end
end

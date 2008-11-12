module ActionSite
  module Generators
    class MarkabyGenerator
      def process(context, content)
        builder = Markaby::Builder.new({}, context)
        builder.instance_eval content, context.file_name
        content = builder.to_s
      end
    end
  end
end

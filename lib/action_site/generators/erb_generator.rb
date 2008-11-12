module ActionSite
  module Generators
    class ErbGenerator
      def process(context, content)
        ERB.new(content, 0, "%<>").result(context.get_binding)
      end
    end
  end
end

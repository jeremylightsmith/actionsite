module ActionSite
  module Generators
    class RedclothGenerator
      def process(context, content)
        redcloth = RedCloth.new(content)
        redcloth.to_html(:html, :textile)
      end
    end
  end
end

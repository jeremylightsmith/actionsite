require 'action_site/page_context'

module ActionSite
  class HtmlGenerator
    attr_reader :template_directory
  
    def initialize(site_context, template_directory, generators)
      @site_context, @template_directory, @generators = 
        site_context, template_directory, generators
    end

    def process_file(file, context = new_context(file), apply_layout = true)
      process(File.basename(file), context, File.read(file), apply_layout)
    rescue
      $stderr.puts "error processing #{file}"
      raise
    end  

    def process(file_name, context, content, apply_layout = true)
      file_name, extension = file_name.split_filename

      generator = @generators[extension]
      if generator
        content = generator.process(context, content)

      elsif extension.nil?
        if apply_layout && context.layout_template
          context.content = content
          return process_file(context.layout_template, context, false)
        else
          return content
        end
      end

      return process(file_name, context, content, apply_layout)
    end
  
    def new_context(file_name = nil)
      PageContext.new(self, @site_context, file_name)
    end
  end
end
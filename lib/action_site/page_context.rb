require 'action_site/context'

require 'action_site/helpers/form_helper'
require 'action_site/helpers/markaby_helper'
require 'action_site/helpers/url_helper'

module ActionSite
  # an instance of this class is created for each page
  # this is how pages can access magical things like link_to, etc
  class PageContext < Context
    include Helpers::FormHelper
    include Helpers::UrlHelper
    include Helpers::MarkabyHelper
    attr_accessor :global_context, :layout_template, :pattern, :content, :file_name
  
    def initialize(html_generator, global_context, file_name)
      @html_generator, @global_context, @file_name = 
        html_generator, global_context, file_name
      layout(:application) rescue nil
    end
  
    def layout(name)
      if name
        files = Dir[File.join(@html_generator.template_directory, 'layouts', "#{name}.*")]
        raise "couldn't find layout #{name}" if files.empty?
        @layout_template = files.first
      else
        @layout_template = nil
      end
    end
    
    def process_file(*args)
      @html_generator.process_file(*args)
    end
  
    def helper(name)
      file_name = "#{name}_helper"
      class_name = file_name.classify
      helper = begin
        class_name.constantize
      rescue NameError # this constant hasn't been loaded yet
        require File.join(@html_generator.template_directory, "helpers", file_name)
        class_name.constantize
      end
    
      metaclass.send(:include, helper)
    end
  
    def content_for(name)
      self.send("content_for_#{name}=".to_sym, yield)
    end
  
    def get_binding
      binding
    end
  
    def method_missing(sym, *args)
      return @global_context.send(sym, *args) if @global_context.respond_to?(sym)

      name = sym.to_s
      if name.starts_with?("content_for_") && name.ends_with?("?")
        return !!instance_variable_get("@#{name[0..-2]}")
      end

      super
    end
  end
end
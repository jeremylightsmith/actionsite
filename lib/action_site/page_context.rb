require 'action_site/context'

require 'action_site/helpers/form_helper'
require 'action_site/helpers/markaby_helper'
require 'action_site/helpers/url_helper'
require 'active_support/core_ext/string/inflections'

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
      helper(:application, false)
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
  
    def helper(name, assert_loaded = true)
      file_name = "#{name}_helper"
      fully_qualified_file = File.join(@html_generator.template_directory, "helpers", file_name + ".rb")
      return unless File.exist?(fully_qualified_file) || assert_loaded
      
      class_name = file_name.classify
      if Object.const_defined?(class_name)
        Object.send(:remove_const, class_name)
      end

      load fully_qualified_file
      metaclass.send(:include, class_name.constantize)
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
      if name.start_with?("content_for_") && name.ends_with?("?")
        return !!instance_variable_get("@#{name[0..-2]}")
      end

      super
    end
  end
end
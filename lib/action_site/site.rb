require 'action_site/context'

require 'action_site/html_generator'

require 'action_site/generators/erb_generator'
require 'action_site/generators/markaby_generator'
require 'action_site/generators/redcloth_generator'
require 'action_site/generators/yaml_generator'

module ActionSite
  EXCLUDED_DIRECTORIES = %w(layouts helpers)
  RESOURCE_EXTENSIONS = %w(css ico gif jpg png js)

  def self.generators
    @generators ||= {
      "erb" => Generators::ErbGenerator.new,
      "mab" => Generators::MarkabyGenerator.new,
      "red" => Generators::RedclothGenerator.new,
      "yml" => Generators::YamlGenerator.new,
      "yaml" => Generators::YamlGenerator.new
    }
  end

  class Site
    attr_reader :context
    
    def initialize(in_dir, out_dir)
      @context = Context.new
      @generator = HtmlGenerator.new(@context, in_dir)
      @in_dir, @out_dir = in_dir, out_dir
      puts "\nGENERATING #{File.basename(in_dir).upcase}\n\n"
      rm_rf out_dir
      mkdir_p out_dir
    end
    
    def generate(in_dir = @in_dir, out_dir = @out_dir)
      Dir[in_dir + "/*"].each do |in_file|
        out_file = in_file.gsub(in_dir, out_dir)

        if excluded?(in_file)
          # nothing
        
        elsif File.symlink?(in_file)
          cp in_file, out_file rescue nil # maybe the links don't exist here

        elsif File.directory?(in_file)
          mkdir_p out_file
          generate in_file, out_file
      
        elsif resource?(in_file)
          ln_s File.expand_path(in_file), File.expand_path(out_file)

        else 
          out_file = out_file.gsub(/\..+$/, '.html')
          generate_page(in_file, out_file)
          puts "   #{in_file} => #{out_file}"
        end
      end
    end
  
    def excluded?(file)
      File.directory?(file) && EXCLUDED_DIRECTORIES.include?(File.basename(file))
    end
  
    def resource?(file)
      RESOURCE_EXTENSIONS.include?(file.extension)
    end
    
    private
    
    def generate_page(in_file, out_file)
      File.open(out_file, "w") do |f| 
        f << @generator.process_file(in_file)
      end
    end
  end
end
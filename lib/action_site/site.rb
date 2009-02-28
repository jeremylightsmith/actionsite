require 'action_site/context'

require 'action_site/html_generator'

require 'action_site/generators/erb_generator'
require 'action_site/generators/markaby_generator'
require 'action_site/generators/redcloth_generator'
require 'action_site/generators/yaml_generator'

require 'thin'

module ActionSite
  EXCLUDED_DIRECTORIES = %w(layouts helpers)
  RESOURCE_EXTENSIONS = %w(css ico gif jpg png js pdf)
  DEFAULT_GENERATORS = {
    "erb" => Generators::ErbGenerator.new,
    "mab" => Generators::MarkabyGenerator.new,
    "red" => Generators::RedclothGenerator.new,
    "yml" => Generators::YamlGenerator.new,
    "yaml" => Generators::YamlGenerator.new
  }
  
  class Site
    include FileUtils
    attr_reader :context
    
    def initialize(in_dir, out_dir)
      @context = Context.new
      @generator = HtmlGenerator.new(@context, in_dir, generators)
      @in_dir, @out_dir = in_dir, out_dir
      puts "\nGENERATING #{File.basename(in_dir).upcase}\n\n"
      rm_rf out_dir
      mkdir_p out_dir
    end
    
    # add / remove / change generators to change the behavior of the html generation
    def generators
      @generators ||= DEFAULT_GENERATORS.dup
    end
    
    def generate(in_dir = @in_dir, out_dir = @out_dir)
      Dir.chdir(@in_dir) do
        Dir["**/*"].each do |path|
          refresh_page path
        end
      end
    end
    
    def refresh_page(path)
      in_file, out_file = File.join(@in_dir, path), File.join(@out_dir, path)

      if !File.exist?(in_file)
        # is there another version that does?
        return unless in_file.extension == "html" && (in_file = Dir[in_file.split_filename[0] + ".*"].first)
      end
          
      if excluded?(in_file)
        # nothing
      
      elsif File.symlink?(in_file)
        mkdir_p File.dirname(out_file)
        cp in_file, out_file rescue nil # maybe the links don't exist here

      elsif File.directory?(in_file)
        mkdir_p out_file
        generate in_file, out_file
    
      elsif resource?(in_file)
        mkdir_p File.dirname(out_file)
        ln_sf File.expand_path(in_file), File.expand_path(out_file)

      else 
        mkdir_p File.dirname(out_file)
        out_file = out_file.gsub(/\..+$/, '.html')
        generate_page(in_file, out_file)
        puts "   #{in_file} => #{out_file}"
      end
    end
    
    def excluded?(file)
      File.directory?(file) && EXCLUDED_DIRECTORIES.include?(File.basename(file))
    end
  
    def resource?(file)
      RESOURCE_EXTENSIONS.include?(file.extension)
    end
    
    def serve(port = 3000)
      app = proc do |env|
        path = env["PATH_INFO"]
        file = File.join("public", "brenda", path)
        if File.directory?(file)
          path = env["PATH_INFO"] = File.join(path, "index.html")
        end

        refresh_page(path)

        Rack::File.new("public/brenda").call(env)
      end

      Thin::Server.start('0.0.0.0', port) do
        use Rack::CommonLogger
        run app
      end
    end
    
    private
    
    def generate_page(in_file, out_file)
      File.open(out_file, "w") do |f| 
        f << @generator.process_file(in_file)
      end
    end
  end
end
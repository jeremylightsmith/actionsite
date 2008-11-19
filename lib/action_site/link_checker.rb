require 'rubygems'
require 'hpricot'
require 'net/http'
require 'uri'

module ActionSite
  class LinkChecker
    def initialize(options = {})
      @options = options
      @checked_urls = []
    end
  
    def check(url, host = nil, indent = "")
      url = url.sub(/\#.*/, '')
      return if url.blank?
      return if @options[:local] && host && !local?(host, url)
      return if @checked_urls.include?(url)
      @checked_urls << url
      
      puts "#{indent}checking #{url}"

      begin
        url, html = fetch(url)
      rescue
        puts "#{url} not found"
        raise
      end
      
      host ||= host_for(url)
      doc = Hpricot(html)

      if local?(host, url)
        (doc / "a").each do |link|
          if child_link = expand_link(url, link["href"])
            begin
              check child_link, host, indent + "   "
            rescue
              puts "from #{url} as #{link}"
              raise
            end
          end
        end
      end
    end
  
    def expand_link(from, to)
      case to
      when nil
        nil
      when /^mailto:.+\@.+\..+/
        nil
      when /^https?\:\/\//
        to
      when /^\//
        File.join(host_for(from), to)
      else
        relative_link(from, to)
      end
    end
    
    def relative_link(from, to)
      from += "." if from.ends_with?("/")
      
      from = from.split("/")
      to = to.split("/")
      
      from.pop
      
      while to[0] == ".."
        to.shift
        from.pop
      end
      
      while to[0] == "."
        to.shift
      end
      
      (from + to).join("/")
    end

    def fetch(url, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      response = Net::HTTP.get_response(URI.parse(url))
      case response
      when Net::HTTPSuccess     then [url, response.body]
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
    end
    
    def host_for(url)
      if url =~ /^(https?\:\/\/[^\/]+\/)/
        $1
      else
        raise "don't know how to get the host for #{url}"
      end
    end
    
    def local?(host, url)
      url.starts_with?(host)
    end
  end
end

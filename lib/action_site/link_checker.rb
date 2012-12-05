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
      url = clean_url(url)
      return if ignore_url?(url, host)
      return if @checked_urls.include?(url)
      @checked_urls << url
      
      puts "#{indent}checking #{url}"

      url, html = fetch(url)
      
      host ||= host_for(url)
      if local?(host, url)
        links_from(html, url).each do |child_url|
          begin
            check child_url, host, indent + "   "
          rescue
            puts "from #{url} as #{link}"
            raise
          end
        end
      end
    end
    
    def clean_url(url)
      url.sub(/\#.*/, '')
    end
    
    def ignore_url?(url, host = nil)
      url.blank? || (@options[:local] && host && !local?(host, url))
    end
    
    def links_from(html, url)
      doc = Hpricot(html)
      (doc / "a").map {|link| expand_link(url, link["href"])}.compact
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
    rescue
      puts "#{url} not found"
      raise
    end
    
    def host_for(url)
      if url =~ /^(https?\:\/\/[^\/]+\/)/
        $1
      else
        raise "don't know how to get the host for #{url}"
      end
    end
    
    def local?(host, url)
      url.start_with?(host)
    end
  end
end

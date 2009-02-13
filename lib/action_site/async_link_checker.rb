module ActionSite
  class AsyncLinkChecker < LinkChecker
    def check(url)
      url, html = fetch(url)
      do_check(host_for(url), 1, url)
    end
    
    def do_check(host, level, *urls)
      return if urls.empty?
      raise "too many levels down" if level > 20
      urls = urls.map {|url| clean_url(url) }.
                  reject {|url| ignore_url?(url, host)}
      urls -= @checked_urls
      @checked_urls += urls
      puts "checking #{level} level(s) down :\n  #{urls.join("\n  ")}\n"
      
      child_urls = []
      urls.map do |url| 
        Thread.new do
          url, html = fetch(url)
          child_urls << links_from(html, url) if local?(host, url)
        end
      end.each {|t| t.join}
      
      do_check(host, level + 1, *child_urls.flatten)
    end
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe ActionSite::LinkChecker do
  attr_reader :links
  
  before do
    @links = ActionSite::LinkChecker.new
  end
  
  it "should calculate correct links" do
    expand_link("http://localhost/bob", "http://google.com").should == "http://google.com"
    expand_link("http://localhost/bob", "http://google.com").should == "http://google.com"
    expand_link("http://localhost/bob", "george").should == "http://localhost/george"
    expand_link("http://localhost/bob/", "george").should == "http://localhost/bob/george"
    expand_link("http://localhost/bob/", ".").should == "http://localhost/bob"
    expand_link("http://localhost/bob", ".").should == "http://localhost"
    expand_link("http://localhost/bob", "..").should == "http:/"
    expand_link("http://localhost/bob/", "..").should == "http://localhost"
    expand_link("http://localhost/a/blues_hero/", "/register.html").should == "http://localhost/register.html"
  end
  
  it "should find get redirects" do
    url, html = links.fetch("http://google.com")
    
    url.should == "http://www.google.com/"
  end
  
  it "should find host for urls" do
    links.host_for("http://foo.bar:3000/").should == "http://foo.bar:3000/"
    links.host_for("http://google.com/").should == "http://google.com/"
    links.host_for("https://google.com/").should == "https://google.com/"
    links.host_for("http://google.com/a/b/c").should == "http://google.com/"
    links.host_for("https://google.com/a/b/c").should == "https://google.com/"
    proc {links.host_for("foo")}.should raise_error
  end
  
  def expand_link(from, to)
    links.expand_link(from, to)
  end
end
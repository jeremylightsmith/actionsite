require File.dirname(__FILE__) + '/../spec_helper'

describe ActionSite::HtmlGenerator do
  include FileSandbox
  attr_reader :generator
  
  before do
    @generator = ActionSite::HtmlGenerator.new(ActionSite::Context.new, 
                                               sandbox.root, 
                                               ActionSite::DEFAULT_GENERATORS)
  end
  
  describe "default generators" do
    it "should have erb, mab, yaml, red" do
      ActionSite::DEFAULT_GENERATORS.keys.sort.should == %w(erb mab red yaml yml)
    end
  end
  
  describe "layouts" do
    it "should show html w/ default layout" do
      sandbox.new :file => 'layouts/application.html.erb', 
                  :with_contents => "<html><body><%= content %></body></html>"

      process("*.html", "foobar").should == "<html><body>foobar</body></html>"
    end
    
    it "should be able to specify a layout" do
      sandbox.new :file => 'layouts/my_layout.html.erb', 
                  :with_contents => "<html><%= content %></html>"

      process("*.html.erb", "% layout 'my_layout'\nfoobar").should == 
                                                              "<html>foobar</html>"
      process("*.html.erb", "% layout :my_layout\nfoobar").should == 
                                                              "<html>foobar</html>"
    end
    
    it "should forget about layout after layout is specified" do
      sandbox.new :file => 'layouts/application.html.erb', :with_contents => "app"
      sandbox.new :file => 'layouts/foo.html.erb', :with_contents => "foo"

      process("*.html", "").should == "app"
      process("*.html.erb", "% layout 'foo'").should == "foo"
      process("*.html", "").should == "app"      
    end
    
    it "should allow a nil layout" do
      process("*.html.erb", "% layout nil\nsomething").should == "something"
      process("*.html.erb", "% layout false\nsomething").should == "something"
    end
  end
  
  describe "helpers" do
    before do
      sandbox.new :file => 'helpers/test_helper.rb', :with_contents => "
        module TestHelper
          def some_test_method
            'hello world'
          end
        end"

      sandbox.new :file => 'helpers/application_helper.rb', 
                  :with_contents => "
        module ApplicationHelper
          def bob
            'the builder'
          end
        end"
        
      sandbox.new :file => "layouts/application.html.erb", 
                  :with_contents => "<%= content %>"
    end
    
    it "should be able to use a helper" do
      process("*.html.erb", "% helper 'test'\n<%= some_test_method %>").
                should == "hello world"
    end
    
    it "should allow multiple helpers with same name between sites" do
      process("*.html.erb", "<%= bob %>").should == "the builder"

      sandbox.new :file => 'helpers/application_helper.rb', 
                  :with_contents => "
        module ApplicationHelper
          def jack
            'the bricklayer'
          end
        end"

        process("*.html.erb", "<%= jack %>").should == "the bricklayer"
        proc {process("*.html.erb", "<%= bob %>")}.should raise_error
    end
    
    it "should include application_helper.rb if it is there" do
      process("*.html.erb", "<%= bob %>").should == "the builder"
    end
  end
  
  describe "content_for" do
    it "should remember a string value" do
      sandbox.new :file => "layouts/application.html.erb", 
                  :with_contents => "head:<%= content_for_head %>"
      process("*.html.erb", "% content_for(:head) { 'bob' }").should == "head:bob"
    end
    
    it "should know if there is content for a given key" do
      sandbox.new :file => "layouts/application.html.erb", 
                  :with_contents => "head:<%= content_for_head? %>, tail:<%= content_for_tail? %>"
                  
      process("*.html.erb", "").should == "head:false, tail:false"
      process("*.html.erb", "% content_for(:tail) { 'a' }").should == "head:false, tail:true"
      process("*.html.erb", "% content_for(:head) { 'bob' }\n% content_for(:tail) {'a'}").should == "head:true, tail:true"
    end
  end
  
  describe "markaby" do
    it "should generate html from markaby" do
      process("*.mab", <<-MAB).should == %{<div class="foo">8</div>}
div.foo do
  text 5 + 3
end
      MAB
    end
    
    it "should be able to have markaby w/in markaby" do
      process("*.mab", <<-MAB).should == %{<div class="foo"><i>photo</i></div>}
def bob
  markaby do
    i { "photo" }
  end
end

div.foo do
  bob
end
      MAB
    end
  end

  def process(extensions, content)
    generator.process(extensions, 
                      generator.new_context(extensions),
                      content)
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

module ActionSite
  describe PageContext do
    include FileSandbox
    attr_reader :context
    
    before do
      @generator = ActionSite::HtmlGenerator.new(ActionSite::Context.new, 
                                                 sandbox.root, 
                                                 ActionSite::DEFAULT_GENERATORS)
      @context = @generator.new_context(nil)
    end
    
    it "should allow setting new variables and accessing them" do
      context.foo = "bar"
      context.foo.should == "bar"
    end
    
    describe "#content_for" do
      it "should handle content for w/ simple block" do
        context.content_for("me") { "your mom" }
      
        context.content_for_me.should == "your mom"
      end

      it "should know if a content_for_block has been specified" do
        context.content_for_me?.should == false
        
        context.content_for("me") { "your mom" }
      
        context.content_for_me?.should == true
      end
    end
  end
end

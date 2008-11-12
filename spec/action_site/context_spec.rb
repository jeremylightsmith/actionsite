require File.dirname(__FILE__) + '/../spec_helper'

module ActionSite
  describe Context do
    it "should allow setting new variables and accessing them" do
      context = Context.new
      context.foo = "bar"
      context.foo.should == "bar"
    end
    
    it "should complain if accessing a variable it doesn't know about" do
      context = Context.new
      proc {context.foo}.should raise_error
    end
  end
end

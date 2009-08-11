require File.dirname(__FILE__) + '/../spec_helper'

describe Reader do
  dataset :groups
  
  before do
    @site = Page.current_site = sites(:test) if defined? Site
  end
  
  it "should have some groups" do
    reader = readers(:normal)
    reader.groups.any?.should be_true
    reader.groups.size.should == 2
  end

end

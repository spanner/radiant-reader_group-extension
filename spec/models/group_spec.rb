require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  dataset :groups, :pages
  
  describe "on validation" do
    before do
      @group = Group.new :name => "Unique Test Group"
      @group.should be_valid
    end
    
    it "should require a name" do
      @group.name = nil
      @group.should_not be_valid
      @group.errors.on(:name).should_not be_empty
    end

    it "should require a unique name" do
      duplicate = Group.new :name => "Normal"
      duplicate.should_not be_valid
      duplicate.errors.on(:name).should_not be_empty
    end
  end

  it "should have a homepage association" do
    Group.reflect_on_association(:homepage).should_not be_nil
    group = groups(:homed)
    group.homepage.should be_a(Page)
    group.homepage = pages(:child)
    group.homepage.should == pages(:child)
  end

  it "should have a group of readers" do
    group = groups(:normal)
    group.readers.any?.should be_true
    group.readers.size.should == 2
  end

  it "should have a group of pages" do
    group = groups(:homed)
    group.pages.any?.should be_true
    group.pages.size.should == 2
  end

end

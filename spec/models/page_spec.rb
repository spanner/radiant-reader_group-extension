require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  dataset :groups
  dataset :pages
  
  before do
    @site = Page.current_site = sites(:test) if defined? Site
  end
  
  describe "with groups" do
    before do
      @page = pages(:parent)
    end
    it "should have some groups" do
      @page.groups.any?.should be_true
      @page.groups.size.should == 1
    end

    it "should be visible to group members" do
      @page.visible_to?(readers(:normal)).should be_true
    end

    it "should not be visible to non-members" do
      @page.visible_to?(readers(:ungrouped)).should be_false
    end
  end

  describe "with inherited groups" do
    before do
      @page = pages(:child)
    end
    
    it "should be visible to group members" do
      @page.visible_to?(readers(:normal)).should be_true
    end

    it "should not be visible to non-members" do
      @page.visible_to?(readers(:ungrouped)).should be_false
    end
  end

  describe "without groups" do
    before do
      @page = pages(:home)
    end
    it "should be visible to everyone" do
      @page.visible_to?(readers(:ungrouped)).should be_true
    end
    
  end

end

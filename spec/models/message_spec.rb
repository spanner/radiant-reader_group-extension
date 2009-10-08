require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  dataset :group_messages
  
  before do
    @site = Page.current_site = sites(:test) if defined? Site
  end
  
  it "should have a group association" do
    Message.reflect_on_association(:group).should_not be_nil
  end
  
  it "should normally list only the ungrouped messages" do
    Message.visible.count.should == 1
  end

  describe "with a group" do
    it "should report itself visible to a reader who is a group member" do
      messages(:grouped).visible_to?(readers(:normal)).should be_true
    end
    it "should report itself invisible to a reader who is not a group member" do
      messages(:grouped).visible_to?(readers(:ungrouped)).should be_false
    end
    it "should list only group members as possible readers" do
      messages(:grouped).possible_readers.include?(readers(:normal)).should be_true
      messages(:grouped).possible_readers.include?(readers(:ungrouped)).should be_false
    end
  end

  describe "without a group" do
    it "should report itself visible to everyone" do
      messages(:normal).visible_to?(readers(:normal)).should be_true
      messages(:normal).visible_to?(readers(:ungrouped)).should be_true
    end

    it "should list all readers as possible readers" do
      messages(:normal).possible_readers.include?(readers(:normal)).should be_true
      messages(:normal).possible_readers.include?(readers(:ungrouped)).should be_true
    end
  end
end

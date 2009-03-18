require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  dataset :groups
  dataset :pages
  
  before do
    controller.stub!(:request).and_return(request)
    Page.current_site = sites(:test) if defined? Site
    request.env["HTTP_REFERER"] = 'http://test.host/referer!'
  end
    
  describe "with no reader" do
    before do
      logout_reader
    end
    
    describe "getting an ungrouped page" do
      before do
        get :show_page, :url => ''
      end
      it "should render the page" do
        response.should be_success
        response.body.should == 'Hello world!'
      end
    end
    describe "getting a grouped page" do
      before do
        get :show_page, :url => 'parent/'
      end
      it "should redirect to reader login" do
        response.should be_redirect
        response.should redirect_to(reader_login_url)
      end
    end
  end
  
  describe "with a reader" do
    before do
      login_as_reader(:normal)
    end

    describe "getting an ungrouped page" do
      before do
        get :show_page, :url => ''
      end
      it "should render the page" do
        response.should be_success
        response.body.should == 'Hello world!'
      end
    end
    describe "getting a grouped page to which she has access" do
      before do
        get :show_page, :url => 'parent/'
      end
      it "should render the page" do
        response.should be_success
        response.body.should == 'Parent body.'
      end
    end
    describe "getting a grouped page to which she doesn't have access" do
      before do
        get :show_page, :url => 'news/'
      end
      it "should render the permission-denied page" do
        response.should be_success
        response.body.should =~ //
      end
    end
  end
end

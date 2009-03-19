require File.dirname(__FILE__) + '/../spec_helper'

describe ReadersController do
  dataset :groups
  dataset :pages
  
  before do
    controller.stub!(:request).and_return(request)
    Page.current_site = sites(:test) if defined? Site
    request.env["HTTP_REFERER"] = 'http://test.host/referer!'
  end
  
  # all we're really testing here is the chaining of Reader.homepage
  # but from a reader pov it's the login behaviour that matters
  
  describe "a logged-in reader requesting a login form" do
    before do
    end
    
    describe "who has a homed group" do
      before do
        login_as_reader(:normal)
        get :login
      end
      
      it "should be redirected to the group's home page" do
        response.should be_redirect
        response.should redirect_to(groups(:homed).homepage.url)
      end
    end

    describe "who doesn't have a homed group" do
      before do
        login_as_reader(:another)
        get :login
      end
      it "should be redirected to that reader's page" do
        response.should be_redirect
        response.should redirect_to(reader_url(readers(:another)))
      end
    end
  end
  
end

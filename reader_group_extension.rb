# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class ReaderGroupExtension < Radiant::Extension
  version "0.4"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :groups
    end
  end
  
  def activate
    Reader.send :include, ReaderGroup::Reader
    Page.send :include, ReaderGroup::Page
    SiteController.send :include, ReaderGroup::SiteControllerExtensions

    UserActionObserver.instance.send :add_observer!, Group 

    # admin.page.edit.add :parts_bottom, "admin/group/page_groups", :before => "edit_timestamp"
    # admin.user.edit.add :form, "admin/user/user_groups", :before => "edit_notes"
    admin.tabs.add "Groups", "/admin/groups", :after => "Layouts", :visibility => [:admin]
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end

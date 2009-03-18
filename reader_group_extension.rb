# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class ReaderGroupExtension < Radiant::Extension
  version "0.4"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"
  
  define_routes do |map|
    map.group_index  'admin/groups', :controller => 'admin/group', :action => 'index'
    map.group_new  'admin/groups/new', :controller => 'admin/group', :action => 'new'
    map.group_edit  'admin/groups/edit/:id', :controller => 'admin/group', :action => 'edit'
    map.group_update  'admin/groups/update/:id', :controller => 'admin/group', :action => 'update'
    map.group_message  'admin/groups/message/:id', :controller => 'admin/group', :action => 'message'
    map.group_populate  'admin/groups/populate/:id', :controller => 'admin/group', :action => 'populate'
    map.group_remove  'admin/groups/remove/:id', :controller => 'admin/group', :action => 'remove'
  end
  
  def activate
    Reader.send :include, ReaderGroup::Reader
    Page.send :include, ReaderGroup::Page
    SiteController.send :include, ReaderGroup::Access

    UserActionObserver.instance.send :add_observer!, Group 

    # admin.page.edit.add :parts_bottom, "admin/group/page_groups", :before => "edit_timestamp"
    # admin.user.edit.add :form, "admin/user/user_groups", :before => "edit_notes"
    admin.tabs.add "Groups", "/admin/groups", :after => "Layouts", :visibility => [:admin]
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end
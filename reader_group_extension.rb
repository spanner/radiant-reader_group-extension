# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class ReaderGroupExtension < Radiant::Extension
  version "0.4"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"
  
  define_routes do |map|
    map.namespace :admin, :member => { 
      :remove => :get, 
      :message => :any, 
      :populate => :any
    } do |admin|
      admin.resources :groups
    end
    map.with_options(:controller => 'admin/groups') do |group|
      group.add_group_reader '/admin/groups/:id/add_reader/:reader',  :action => 'add_reader'
      group.remove_group_reader '/admin/groups/:id/remove_reader/:reader',  :action => 'remove_reader'
      group.add_group_page '/admin/groups/:id/add_page/:page',  :action => 'add_page'
      group.remove_group_page '/admin/groups/:id/remove_page/:page',  :action => 'remove_page'
    end
  end
  
  def activate
    Reader.send :include, ReaderGroup::Reader
    Page.send :include, ReaderGroup::Page
    SiteController.send :include, ReaderGroup::SiteControllerExtensions

    Radiant::AdminUI.send :include, ReaderGroup::AdminUI unless defined? admin.group
    admin.group = Radiant::AdminUI.load_default_group_regions

    UserActionObserver.instance.send :add_observer!, Group 

    if defined? Site && admin.sites       # currently we know it's the spanner multi_site if admin.sites is defined
      Site.send :include, ReaderGroup::Site
      admin.group.index.add :top, "admin/shared/site_jumper"
    end

    admin.page.edit.add :parts_bottom, "page_groups", :before => "edit_timestamp"
    admin.reader.edit.add :form, "reader_groups", :before => "edit_notes"

    admin.tabs.add "Groups", "/admin/groups", :after => "Readers", :visibility => [:admin]
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end

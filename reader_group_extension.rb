require_dependency 'application_controller'

class ReaderGroupExtension < Radiant::Extension
  version "0.8"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"

  define_routes do |map|
    map.namespace :admin, :path_prefix => 'admin/readers', :member => {
      :remove => :get,
      :message => :any, 
      :populate => :any      
    } do |admin|
      admin.resources :groups, :has_many => [:memberships, :permissions]
    end
  end
  
  extension_config do |config|
    config.extension 'reader'
  end
  
  def activate
    Reader.send :include, ReaderGroup::Reader
    Page.send :include, ReaderGroup::Page
    SiteController.send :include, ReaderGroup::SiteControllerExtensions
    Site.send :has_many, :groups if defined? Site
    UserActionObserver.instance.send :add_observer!, Group 
    ReaderGroup::Exception

    unless defined? admin.group
      Radiant::AdminUI.send :include, ReaderGroup::AdminUI
      admin.group = Radiant::AdminUI.load_default_group_regions
      admin.page.edit.add :parts_bottom, "page_groups", :before => "edit_timestamp"
      admin.reader.edit.add :form, "reader_groups", :before => "edit_notes"
    end

    admin.tabs['Readers'].add_link('reader groups', '/admin/readers/groups')
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end


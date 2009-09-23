require_dependency 'application_controller'

class ReaderGroupExtension < Radiant::Extension
  version "0.8"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"

  define_routes do |map|
    map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
      admin.resources :groups, :has_many => [:memberships, :permissions, :group_invitations]
    end
  end
  
  extension_config do |config|
    config.extension 'reader'
  end
  
  def activate
    Reader.send :include, ReaderGroup::Reader                                     # defines group associations
    Page.send :include, ReaderGroup::Page                                         # group associations and visibility decisions
    ReaderNotifier.send :include, ReaderGroup::NotifierExtensions                 # a couple of new message types
    Message.send :include, ReaderGroup::MessageExtensions                   # group association
    SiteController.send :include, ReaderGroup::SiteControllerExtensions           # access control based on group membership

    UserActionObserver.instance.send :add_observer!, Group 
    ReaderGroup::Exception

    unless defined? admin.group                                                   # to avoid duplicate partials
      Radiant::AdminUI.send :include, ReaderGroup::AdminUI
      admin.group = Radiant::AdminUI.load_default_group_regions
      admin.page.edit.add :parts_bottom, "page_groups", :before => "edit_timestamp"
      admin.reader.edit.add :form, "reader_groups", :before => "edit_notes"
    end

    admin.tabs['Readers'].add_link('groups', '/admin/readers/groups')      # add_link is defined by the submenu extension
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end


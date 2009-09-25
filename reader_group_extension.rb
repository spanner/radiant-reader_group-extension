require_dependency 'application_controller'

class ReaderGroupExtension < Radiant::Extension
  version "0.8"
  description "Page access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"

  define_routes do |map|
    map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
      admin.resources :groups, :has_many => [:memberships, :permissions, :group_invitations, :messages]
    end
  end
  
  extension_config do |config|
    config.extension 'reader'
  end
  
  def activate
    ReaderGroup::Exception
    Reader.send :include, ReaderGroup::Reader                                     # defines group associations
    Page.send :include, ReaderGroup::Page                                         # group associations and visibility decisions
    Message.send :include, ReaderGroup::Message                                   # group association

    ReaderNotifier.send :include, ReaderGroup::NotifierExtensions                 # a couple of new message types
    SiteController.send :include, ReaderGroup::SiteControllerExtensions           # access control based on group membership
    Admin::MessagesController.send :include, ReaderGroup::MessagesControllerExtensions    # supports specification of group on newing of message
    UserActionObserver.instance.send :add_observer!, Group 

    Page.send :include, ReaderGroup::GroupMessageTags                             # extra tags for talking about groups in mailouts

    unless defined? admin.group                                                   # to avoid duplicate partials
      Radiant::AdminUI.send :include, ReaderGroup::AdminUI
      admin.group = Radiant::AdminUI.load_default_group_regions
      admin.page.edit.add :parts_bottom, "page_groups", :before => "edit_timestamp"
      admin.reader.edit.add :form, "reader_groups", :before => "edit_notes"
      admin.messages.edit.add :form, "admin/messages/edit_group", :after => "edit_filter"
      admin.messages.show.add :delivery, "admin/messages/delivery_group", :before => "deliver_all"

      # how to get at message object in these partials?
      # admin.messages.index.add :thead, "admin/messages/group_header", :after => "subject_header"
      # admin.messages.index.add :tbody, "admin/messages/group_cell", :after => "subject_cell"
    end

    admin.tabs['Readers'].add_link('groups', '/admin/readers/groups')      # add_link is defined by the submenu extension
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end


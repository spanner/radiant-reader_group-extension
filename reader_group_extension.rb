require_dependency 'application_controller'

module ReaderGroup
  class Exception < StandardError
    def initialize(message = "Sorry: group problem"); super end
  end
  class PermissionDenied < Exception
    def initialize(message = "Sorry: you don't have access to that"); super end
  end
end

class ReaderGroupExtension < Radiant::Extension
  version "0.81"
  description "Page (and other) access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"

  define_routes do |map|
    map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
      admin.resources :groups, :has_many => [:memberships, :permissions, :group_invitations, :messages]
    end
    map.resources :groups, :only => [] do |group|
      group.resources :messages, :only => [:index, :show], :member => [:preview]
    end
  end
  
  extension_config do |config|
    config.extension 'reader'
  end
  
  def activate
    ActiveRecord::Base.send :include, GroupedModel                                    # is_grouped mechanism for any model that can belong_to a group
                                                                                      # here it's only used for messages: the other associations are habtm
    
    Reader.send :include, GroupedReader                                               # defines group associations
    Page.send :include, GroupedPage                                                   # group associations and visibility decisions
    Message.send :include, GroupedMessage                                             # group association

    ReaderNotifier.send :include, ReaderNotifierExtensions                            # a couple of new message types
    SiteController.send :include, SiteControllerExtensions                            # access control based on group membership
    ReadersController.send :include, ReadersControllerExtensions                      # offer subscription to public groups
    MessagesController.send :include, MessagesControllerExtensions                    # listing and display of group messages
    Admin::MessagesController.send :include, AdminMessagesControllerExtensions        # supports specification of group on newing of message
    ReaderSessionsController.send :include, ReaderSessionsControllerExtensions        # sends newly logged-in readers to a group home page if one can be found
    ReaderActivationsController.send :include, ReaderActivationsControllerExtensions  # sends newly activated readers to a group home page if one can be found
    UserActionObserver.instance.send :add_observer!, Group                            # the usual date-stamping and ownership
    MessageFunction.add('group_welcome', 'Group-membership notification')
    Page.send :include, GroupMessageTags                                              # extra tags for talking about groups in mailouts


    unless defined? admin.group                                                       # to avoid duplicate partials
      Radiant::AdminUI.send :include, GroupUI
      admin.group = Radiant::AdminUI.load_default_group_regions
      admin.page.edit.add :parts_bottom, "page_groups", :before => "edit_timestamp"
      admin.reader.edit.add :form, "reader_groups", :before => "edit_notes"
      admin.messages.edit.add :form, "admin/messages/edit_group", :after => "edit_filter_and_status"
      admin.messages.show.add :delivery, "admin/messages/delivery_group", :before => "deliver_all"

      # how can I get at the in-loop message object in these?
      # admin.messages.index.add :thead, "admin/messages/group_header", :after => "subject_header"
      # admin.messages.index.add :tbody, "admin/messages/group_cell", :after => "subject_cell"
    end
    
    tab("Readers") do
      add_item 'groups', '/admin/readers/groups'
    end
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end


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
  version "1.0.0"
  description "Page (and other) access control for site readers and groups"
  url "http://spanner.org/radiant/reader_group"

  def activate
    Group
    ActiveRecord::Base.send :include, GroupedModel                                    # is_grouped mechanism for any model that can belong_to a group
    
    Reader.send :include, GroupedReader                                               # defines group associations
    Page.send :include, GroupedPage                                                   # group associations and visibility decisions
    Message.send :include, GroupedMessage                                             # group association

    ReaderNotifier.send :include, ReaderNotifierExtensions                            # a couple of new message types
    SiteController.send :include, SiteControllerExtensions                            # access control based on group membership
    ReadersController.send :include, ReadersControllerExtensions                      # offer subscription to public groups
    Admin::MessagesController.send :include, AdminMessagesControllerExtensions        # preview and delivery
    ReaderSessionsController.send :include, ReaderSessionsControllerExtensions        # sends newly logged-in readers to a group home page if one can be found
    ReaderActivationsController.send :include, ReaderActivationsControllerExtensions  # sends newly activated readers to a group home page if one can be found
    UserActionObserver.instance.send :add_observer!, Group                            # the usual date-stamping and ownership
    Page.send :include, GroupMessageTags                                              # extra tags for talking about groups in mailouts

    unless defined? admin.group                                                       # to avoid duplicate partials
      Radiant::AdminUI.send :include, GroupUI
      Radiant::AdminUI.load_reader_group_extension_regions
    end

    admin.page.edit.add :parts_bottom, "page_groups"
    admin.reader.edit.add :form, "reader_groups", :before => :edit_description
    admin.message.edit.add :body_bottom, "message_group"

    tab("Readers") do
      add_item 'Groups', '/admin/readers/groups', :before => 'Settings'
    end
  end
  
  def deactivate
  end
  
end


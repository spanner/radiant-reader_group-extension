module GroupedReader

  def self.included(base)
    base.class_eval {
      has_many :memberships
      has_many :groups, :through => :memberships
      include InstanceMethods
      alias_method_chain :activate!, :group
      alias_method_chain :send_functional_message, :group
    }
  end

  module InstanceMethods     
  
    def find_homepage
      if homegroup = groups.with_home_page.first
        homegroup.homepage
      end
    end
  
    def can_see? (this)
      permitted_groups = this.permitted_groups
      permitted_groups.empty? or in_any_of_these_groups?(permitted_groups)
    end
      
    def in_any_of_these_groups? (grouplist)
      (grouplist & groups).any?
    end
  
    def is_in? (group)
      groups.include?(group)
    end
    
    # has_group? is ambiguous: with no argument it means 'is this reader grouped at all?'.
    def has_group?(group=nil)
      group.nil? ? groups.any? : is_in?(group)
    end
    
    # if group-welcome messages exist for this reader's memberships, they will be sent on activation
    def activate_with_group!
      send_group_welcomes if activate_without_group!
    end

    # there may be versions of the functional (eg welcome) messages specific to a group
    # (which has to be passed through, so this currently only happens when sending out group invitations but ought to be useful elsewhere too)
    def send_functional_message_with_group(function, group=nil)
      reset_perishable_token!
      message = Message.functional(function, group)   # returns the standard functional message if no group is supplied, or no group message exists
      message.deliver_to(self) if message
    end
    
    def send_group_invitation_message(group=nil)
      send_functional_message_with_group('invitation', group)
    end

  protected

    def send_group_welcomes
      groups.each { |g| g.send_welcome_to(self) }
    end
  
  end
end

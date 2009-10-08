module GroupedReader

  def self.included(base)
    base.class_eval {
      has_many :memberships
      has_many :groups, :through => :memberships
      include InstanceMethods
      alias_method_chain :activate!, :group
    }
  end

  module InstanceMethods     
  
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
    
    def activate_with_group!
      send_group_welcomes if activate_without_group!
    end
        
  protected
    def send_group_welcomes
      groups.each { |g| g.send_welcome_to(self) }
    end
  
  end
end

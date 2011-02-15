module GroupedMessage

  def self.included(base)
    base.class_eval {
      has_groups

      include InstanceMethods
      alias_method_chain :possible_readers, :groups
      alias_method_chain :inactive_readers, :groups
      
      extend ClassMethods
      class << self
        alias_method_chain :functional, :groups
      end
    }
  end
  
  module InstanceMethods
    def possible_readers_with_groups
      groups.any? ? Reader.in_groups(groups).active : possible_readers_without_groups
    end
    def inactive_readers_with_groups
      groups.any? ? Reader.in_groups(groups).inactive : inactive_readers_without_groups
    end
  end
  
  module ClassMethods
    def functional_with_groups(function, group=nil)
      messages = for_function(function)
      if group
        messages.for_group(group).first
      else
        messages.ungrouped.first
      end
    end
  end

end

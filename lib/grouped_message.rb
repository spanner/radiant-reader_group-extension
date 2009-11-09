module GroupedMessage

  def self.included(base)
    base.class_eval {
      is_grouped

      include InstanceMethods
      alias_method_chain :possible_readers, :group
      alias_method_chain :inactive_readers, :group
      
      extend ClassMethods
      class << self
        alias_method_chain :functional, :group
      end
    }
  end
  
  module InstanceMethods
    def possible_readers_with_group
      group ? group.readers.active : possible_readers_without_group
    end
    def inactive_readers_with_group
      group ? group.readers.inactive : inactive_readers_without_group
    end
  end
  
  module ClassMethods
    def functional_with_group(function, group=nil)
      messages = published.for_function(function)
      if group && messages.for_group(group).any?
        messages.for_group(group).first
      else
        messages.ungrouped.first
      end
    end
  end

end

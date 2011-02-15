module GroupedPage

  def self.included(base)
    base.class_eval {
      has_groups
      has_one :homegroup, :foreign_key => 'homepage_id', :class_name => 'Group'
      include InstanceMethods
      alias_method_chain :permitted_groups, :inheritance
    }
  end
  
  module InstanceMethods
    
    # this is all very inefficient recursive stuff
    # but the ancestor pages should be in memory already
    # and the groups check is now a single query

    def inherited_groups
      lineage = self.ancestors
      if lineage.any?
        Group.attached_to(lineage)
      else
        []
      end
    end

    def permitted_groups_with_inheritance
      permitted_groups_without_inheritance + inherited_groups
    end

    # any page with a group-marker is never cached
    # so that we can return cache hits with confidence
    # this call is regrettably expensive
    def cache?
      self.permitted_groups.empty?
    end        

    def has_inherited_group?(group)
      return self.inherited_groups.include?(group)
    end
    
    def group_is_inherited?(group)
      return self.has_inherited_group?(group) && !self.has_group?(group)
    end
    
  end

end



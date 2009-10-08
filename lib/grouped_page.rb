module GroupedPage

  def self.included(base)
    base.class_eval {
      has_many :permissions
      has_many :groups, :through => :permissions
      has_one :group, :foreign_key => 'homepage_id'
      include InstanceMethods
      
      # any page with a group-marker is never cached
      # so that we can continue to return cache hits without care
      # this check is regrettably expensive

      def cache?
        self.inherited_groups.empty?
      end        
    }
  end
  
  module InstanceMethods
    
    def visible_to?(reader)
      permitted_groups = self.inherited_groups  
      return true if permitted_groups.empty?
      return false if reader.nil?
      return true if reader.is_admin?
      return reader.in_any_of_these_groups?(permitted_groups)
    end

    # this is all very inefficient recursive stuff
    # but to do it in one pass we'd have to build a list of pages anyway
    # so there isn't much to gain unless we shift to a different kind of tree

    def inherited_groups
      if (self.parent.nil?)
        self.groups
      else
        self.groups + self.parent.inherited_groups
      end
    end
    alias permitted_groups inherited_groups

    def has_group?(group)
      return self.groups.include?(group)
    end

    def has_inherited_group?(group)
      return self.inherited_groups.include?(group)
    end
    
    def group_is_inherited?(group)
      return self.has_inherited_group?(group) && !self.has_group?(group)
    end
    
  end

end



module ReaderGroup::Page

  def self.included(base)
    base.class_eval {
      has_many :group_permissions
      has_many :groups, :through => :group_permissions
      include InstanceMethods
    }
  end
  
  module InstanceMethods     
    
    def visible_to?(reader)      
      return true if self.inherited_groups.empty?
      return false if reader.nil?
      return false if reader.groups.empty?
      return !(self.inherited_groups & reader.groups ).empty? 
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

    def has_group?(group)
      return self.groups.include?(group)
    end

    def has_inherited_group?(group)
      return self.inherited_groups.include?(group)
    end
    
    def group_is_inherited?(group)
      return self.has_inherited_group?(group) && !self.has_group?(group)
    end

    # any page with a group-marker is never cached
    # so that we can continue to return cache hits without care
    # this check is regrettably expensive

    def cache?
      self.inherited_groups.any?
    end        
  end

end



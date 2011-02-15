module GroupedModel
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_groups?
      false
    end
    alias :has_group? :has_groups?
    
    def has_groups(options={})
      return if has_groups?
      
      class_eval {
        extend GroupedModel::GroupedClassMethods
        include GroupedModel::GroupedInstanceMethods

        unless instance_methods.include? 'visible_to?'
          def visible_to?(reader)
            return true
          end
        end
        alias_method_chain :visible_to?, :groups
      }
      
      has_many :permissions, :as => :permitted
      has_many :groups, :through => :permissions
      Group.define_retrieval_methods(self.to_s)

      named_scope :ungrouped, {
        :select => "#{self.table_name}.*, count(pp.id) as group_count",
        :joins => "LEFT OUTER JOIN permissions as pp on pp.permitted_id = #{self.table_name}.id AND pp.permitted_type = '#{self.to_s}'", 
        :having => "group_count = 0",
        :group => column_names.map { |n| self.table_name + '.' + n }.join(','),    # postgres requires that we group by all selected (but not aggregated) columns
        :readonly => false
      } do
        def count
          length
        end
      end

      named_scope :grouped, {
        :select => "#{self.table_name}.*, count(pp.id) as group_count",
        :joins => "LEFT OUTER JOIN permissions as pp on pp.permitted_id = #{self.table_name}.id AND pp.permitted_type = '#{self.to_s}'", 
        :having => "group_count > 0",
        :group => column_names.map { |n| self.table_name + '.' + n }.join(','),
        :readonly => false
      } do
        def count
          length
        end
      end
      
      named_scope :for_group, lambda { |group| 
        {
          :joins => "INNER JOIN permissions as pp on pp.permitted_id = #{self.table_name}.id AND pp.permitted_type = '#{self.to_s}'", 
          :conditions => ["pp.group_id = ?)", group.id],
          :group => column_names.map { |n| self.table_name + '.' + n }.join(','),
          :readonly => false
        }
      }
            
      named_scope :visible_to, lambda { |reader| 
        groups = reader.nil? ? [] : reader.groups
        {:conditions => ["group_id IS NULL OR group_id IN(?)", groups.map(&:id).join(',')]} 
      }
    end
    alias :has_group :has_groups
  end

  module GroupedClassMethods
    def has_groups?
      true
    end
    
    def visible
      ungrouped
    end
  end

  module GroupedInstanceMethods

    # in GroupedPage this is chained to include inherited groups
    def permitted_groups
      groups
    end

    def visible_to_with_groups?(reader)
      return false unless visible_to_without_groups?(reader)
      return true if self.permitted_groups.empty?
      return false if reader.nil?
      return true if reader.is_admin?
      return (reader.groups & self.permitted_groups).any?
    end

    def group
      if self.permitted_groups.length == 1
        self.permitted_groups.first
      else
        nil
      end
    end
    
    def visible?
      permitted_groups.empty?
    end

    def permitted_readers
      permitted_groups.any? ? Reader.in_groups(permitted_groups) : Reader.all
    end
    
    def has_group?(group)
      return self.permitted_groups.include?(group)
    end
    
    def permit(group)
      self.groups << group unless self.has_group?(group)
    end

    def group_ids=(ids)
      self.groups = Group.from_list(ids)
    end
  end
end

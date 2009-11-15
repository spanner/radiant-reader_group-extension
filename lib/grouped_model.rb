module GroupedModel
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def is_grouped?
      false
    end
    
    def is_grouped(options={})
      return if is_grouped?
      cattr_accessor :group_recipients, :group_donor
      
      class_eval {
        extend GroupedModel::GroupedClassMethods
        include GroupedModel::GroupedInstanceMethods

        def visible_to?(reader)
          return true unless group
          return false unless reader
          return true if reader.is_user?
          return true if reader.is_in?(group)
          return false
        end

      }
      
      belongs_to :group
      named_scope :ungrouped, {:conditions => 'group_id IS NULL'}
      named_scope :for_group, lambda { |g| {:conditions => ["group_id = ?", g]} }
      named_scope :visible_to, lambda { |reader| 
        groups = reader.nil? ? [] : reader.groups
        {:conditions => ["group_id IS NULL OR group_id IN(?)", groups.map(&:id).join(',')]} 
      }
      
      Group.send(:has_many, self.to_s.pluralize.underscore.intern)

      before_create :get_group
      after_save :give_group
    end
  end

  module GroupedClassMethods
    def visible
      ungrouped
    end
    
    def is_grouped?
      true
    end
    
    def gets_group_from(association_name)
      association = reflect_on_association(association_name)
      raise StandardError "can't find group source '#{association_name}" unless association
      raise StandardError "#{association.klass} is not grouped and cannot be a group donor" unless association.klass.is_grouped? 
      self.group_donor = association_name
    end
    
    def gives_group_to(associations)
      associations = [associations] unless associations.is_a?(Array)
      # shall we force is_grouped here?
      # shall we assume that gets_group_from follows? and find the association somehow?
      self.group_recipients ||= []
      self.group_recipients += associations
    end
  end

  module GroupedInstanceMethods

    def visible?
      !!group
    end

    def permitted_groups
      [group]
    end

  protected

    def get_group
      if self.class.group_donor && group_source = self.send(self.class.group_donor)
        self.group = group_source.group
      end
    end

    def give_group
      if self.class.group_recipients
        self.class.group_recipients.each do |association|
          send(association).each do |associate|
            unless associate.group == group
              associate.group = group 
              associate.save(false)
            end
          end
        end
      end
    end
  end
end

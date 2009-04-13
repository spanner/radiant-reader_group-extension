module ReaderGroup::Reader

  def self.included(base)
    base.class_eval {
      has_and_belongs_to_many :groups
      include InstanceMethods
      
      def homepage_with_group
        if groups && homegroup = groups.detect{ |g| !g.homepage.nil? }
          homegroup.homepage.url
        else
          homepage_without_group
        end
      end
      alias_method_chain :homepage, :group

      def activate_with_group!
        send_group_welcomes if activate_without_group!
      end
      alias_method_chain :activate!, :group

    }
  end

  module InstanceMethods     
  
    def can_see? (this)   # this might be page or forum, so far
      grouplist = this.inherited_groups
      grouplist.empty? or in_any_of_these_groups?(grouplist)
    end
      
    def in_any_of_these_groups? (grouplist)
      grouplist.any? { |g| groups.include? g }
    end
  
    def is_in? (group)
      in_any_of_these_groups?([group])
    end
  
    def send_group_welcomes
      groups.each { |g| g.send_welcome_to(self) }
    end
  
  end
end

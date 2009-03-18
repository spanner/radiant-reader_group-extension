module ReaderGroup::Reader

  def self.included(base)
    base.class_eval {
      has_and_belongs_to_many :groups
      include InstanceMethods
    }
  end

  module InstanceMethods     
  
    def home_page
      lg = groups.detect{ |g| !g.home_page.nil? }
      lg.home_page.url if lg
    end
      
    def can_see? (page)
      grouplist = page.inherited_groups
      grouplist.empty? or in_any_of_these_groups?(grouplist)
    end
      
    def in_any_of_these_groups? (grouplist)
      grouplist.any? { |g| groups.include? g }
    end
  
    def is_in? (group)
      in_any_of_these_groups?([group])
    end
  
  end
end

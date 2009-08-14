class Permission < ActiveRecord::Base

  belongs_to :group
  belongs_to :page
  
  named_scope :for, lambda { |page|
    {
      :conditions => ["permissions.page_id = ?", page.id]
    }
  }
  
end


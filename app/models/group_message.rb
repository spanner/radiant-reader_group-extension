class GroupMessage < ActiveRecord::Base

  is_site_scoped if defined? ActiveRecord::SiteNotFound
  default_scope :order => 'created_at DESC'

  belongs_to :group
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  validates_presence_of :subject
  validates_presence_of :body

  object_id_attr :filter, TextFilter
  
  named_scope :delivered, {
    :conditions => "sent_at IS NOT NULL and sent_at <= NOW()"
  }
  
  def filtered_body
    filter.filter(body)
  end
  
  def delivered?
    sent_at && sent_at <= Time.now
  end
  
  def sample
    ReaderNotifier.create_group_message(group.readers.first, self)
  end
  
  def deliver
    group.readers.each do |reader|
      ReaderNotifier.deliver_group_message(reader, self) 
    end
  end
end

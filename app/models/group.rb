class Group < ActiveRecord::Base

  is_site_scoped if defined? ActiveRecord::SiteNotFound
  default_scope :order => 'name'

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :homepage, :class_name => 'Page'

  has_many :permissions
  has_many :pages, :through => :permissions
  has_many :memberships
  has_many :readers, :through => :memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
    
  def send_welcome_to(reader)
    GroupNotifier::deliver_welcome_message(reader, self) if reader.activated?     # welcomes will be sent on activation
  end

  def send_message_to(reader, subject, message)
    GroupNotifier::deliver_this_message(reader, self, subject, message)
  end

  def send_message_to_all(subject, message)
    count = 0
    self.readers.each do |reader| 
      count += 1
      self.send_message_to(reader, subject, message) 
    end
    count
  end
  
  def permission_for(page)
    self.permissions.for(page).first
  end

  def membership_for(reader)
    self.memberships.for(reader).first
  end

end


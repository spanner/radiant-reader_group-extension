class Group < ActiveRecord::Base

  is_site_scoped if defined? ActiveRecord::SiteNotFound
  default_scope :order => 'name'

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :homepage, :class_name => 'Page'

  has_many :messages
  has_many :permissions
  has_many :pages, :through => :permissions
  has_many :memberships
  has_many :readers, :through => :memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  named_scope :with_home_page, { :conditions => "homepage_id IS NOT NULL", :include => :homepage }
  named_scope :subscribable, { :conditions => "public = 1" }
  named_scope :unsubscribable, { :conditions => "public = 0" }
  
  def url
    homepage.url if homepage
  end
  
  def send_welcome_to(reader)
    if reader.activated?                                        # welcomes will be triggered again on activation
      message = messages.for_function('group_welcome').first    # only if a group_welcome message exists *belonging to this group*
      message.deliver_to(reader) if message                     # (the belonging also allows us to mention the group in the message)
    end
  end

  def permission_for(page)
    self.permissions.for(page).first
  end

  def membership_for(reader)
    self.memberships.for(reader).first
  end

end


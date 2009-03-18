class Group < ActiveRecord::Base

  class PermissionDenied < StandardError
    def initialize(message = "Sorry: you don't have access to that page"); super end
  end

  is_site_scoped      # if multi_site is not installed then reader will spoof this call
  order_by 'name'

  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  belongs_to :home_page, :class_name => 'Page'

  has_and_belongs_to_many :readers
  has_and_belongs_to_many :pages
  
  validates_presence_of :name
  validates_uniqueness_of :name
    
  def send_welcome_to(reader)
    GroupNotifier::deliver_welcome_message(user)
  end

  def send_message_to(reader, subject, message)
    GroupNotifier::deliver_this_message(reader, self, subject, message)
  end

  def send_message_to_all(subject, message)
    self.readers.each { |reader| self.send_message_to(reader, subject, message) }
  end

end


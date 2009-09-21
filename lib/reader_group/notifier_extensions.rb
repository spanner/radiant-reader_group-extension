module ReaderGroup::NotifierExtensions
  
  def group_welcome_message( reader, group )
    setup_email(reader, group)
    @subject = "Welcome to the #{group.name} group"
    @body[:group] = group
  end

  def group_message( reader, group, subject, message )
    setup_email(reader, group)
    @subject = subject
    @body[:message] = message
    @body[:group] = group
  end

end

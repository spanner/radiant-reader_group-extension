module ReaderGroup::NotifierExtensions
  
  def group_welcome_message( reader, group )
    setup_email(reader)
    @subject = "Welcome to the #{group.name} group"
    @body[:group] = group
  end

  def group_message( reader, group_message )
    setup_email(reader)
    @subject = group_message.subject
    @body[:message] = group_message.filtered_body
    @body[:group] = group_message.group
    @body[:sender] = group_message.created_by
  end

end

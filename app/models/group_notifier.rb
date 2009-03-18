class GroupNotifier < ActionMailer::Base

  def invitation_message( reader )
    @recipients = reader.email
    @from = "William Ross <will@spanner.org>"   #*** todo
    @subject = "*** todo"
    @body[:reader] = reader
    @body[:password] = reader.clear_password
  end

  def welcome_message( reader )
    @recipients = reader.email
    @from = "William Ross <will@spanner.org>"   #*** todo
    @subject = "*** todo"
    @body[:reader] = reader
  end

  def this_message( reader, group, subject, message )
    @recipients = reader.email
    @from = "William Ross <will@spanner.org>"   #*** todo
    @subject = subject
    @body[:reader] = reader
    @body[:message] = message
    @body[:group] = group
  end

end

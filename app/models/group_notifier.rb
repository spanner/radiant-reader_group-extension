class GroupNotifier < ActionMailer::Base

  def welcome_message( reader, group )
    setup_email(reader, group)
    @subject = "Welcome to the #{group.name} group"
  end

  def this_message( reader, group, subject, message )
    setup_email(reader, group)
    @subject = subject
    @body[:message] = message
  end

protected

  def setup_email(reader, group)
    site = reader.site if reader.respond_to?(:site)
    default_url_options[:host] = site ? site.base_domain : Radiant::Config['site.url'] || 'www.example.com'
    @from = site ? site.mail_from_address : Radiant::Config['site.mail_from_address']
    @content_type = 'text/plain'
    @recipients = "#{reader.email}"
    @subject = ""
    @sent_on = Time.now
    @body[:reader] = reader
    @body[:sender] = site ? site.mail_from_name : Radiant::Config['site.mail_from_name']
    @body[:sending_email] = @from
    @body[:site_title] = site ? site.name : Radiant::Config['site.title']
    @body[:site_url] = site ? site.base_domain : Radiant::Config['site.url']
    @body[:login_url] = reader_login_url
    @body[:my_url] = reader_url(reader)
    @body[:prefs_url] = edit_reader_url(reader)
    @body[:group] = group
  end

end

module Admin::GroupHelper

  def message_preview(subject, body)
    preview = <<EOM
<blockquote><p>
From: #{current_user.name} &lt;#{current_user.email}&gt;
To: [each person's email addresses]
Date: #{Time.now.to_date.to_s :long}
<strong>Subject: #{subject}</strong>

Dear [each person's full name]

#{body}

</p></blockquote>
EOM
  end

end
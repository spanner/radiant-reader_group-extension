module Admin::GroupsHelper

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
  
  def choose_page(object, field, select_options={})
    options = page_option_branch(Page.homepage)
    options.unshift ['<default>', nil]
    select object, field, options, select_options
  end
    
  def page_option_branch(page, depth=0)
    options = []
    options << ["#{". " * depth}#{h(page.title)}", page.id]
    page.children.each do |child|
      options += page_option_branch(child, depth + 1)
    end
    options
  end

end

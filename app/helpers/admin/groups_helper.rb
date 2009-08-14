module Admin::GroupsHelper

  def message_preview(subject, body, reader)
    preview = <<EOM
From: #{current_user.name} &lt;#{current_user.email}&gt;
To: #{reader.name} &lt;#{reader.email}&gt;
Date: #{Time.now.to_date.to_s :long}
<strong>Subject: #{subject}</strong>

Dear #{reader.name},

#{body}

EOM
  simple_format(preview)
  end
  
  def choose_page(object, field, select_options={})
    root = Page.respond_to?(:homepage) ? Page.homepage : Page.find_by_parent_id(nil)
    options = page_option_branch(root)
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

module ReaderGroup::GroupMessageTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  desc %{
    The root 'group' tag is not meant to be called directly. 
    All it does is summon a reader object so that its fields can be displayed with eg.
    <pre><code><r:group:name /></code></pre>
  }
  tag 'group' do |tag|
    raise TagError, "no group" unless tag.locals.group = @mailer_vars[:@group]
    tag.expand
  end
  
  [:name, :description, :url].each do |field|
    desc %{
      Only for use in email messages. Displays the #{field} field of the currently relevant group.
      <pre><code><r:group:#{field} /></code></pre>
    }
    tag "group:#{field}" do |tag|
      tag.locals.group.send(field)
    end
  end

end

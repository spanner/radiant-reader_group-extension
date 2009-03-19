class Admin::GroupsController < Admin::ResourceController

  only_allow_access_to :index, :new, :edit, :remove, :members, :when => :admin,
    :denied_url => {:controller => 'page', :action => :index},
    :denied_message => 'You must have admin privileges to work on user groups.'
  
  private

    def generate_login(name)
      logger.warn "... #{name}"
      names = name.split
      initials = names.map {|n| n.slice(0,1)}
      initials.pop
      initials.push(names.last).join('_')
    end

    def generate_password(length=8)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
      Array.new(8, '').collect{chars[rand(chars.size)]}.join
    end
  
end

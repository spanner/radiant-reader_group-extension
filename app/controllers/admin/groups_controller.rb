class Admin::GroupController < Admin::AbstractModelController

  model_class Group

  only_allow_access_to :index, :new, :edit, :remove, :members, :when => :admin,
    :denied_url => {:controller => 'page', :action => :index},
    :denied_message => 'You must have admin privileges to work on user groups.'
  
  def message
    @group = Group.find(params[:id])
    if request.post? && params[:confirm]
      @group.send_message_to_all(params[:subject], params[:message])
      flash[:notice] = 'Message sent to group.'
      redirect_to group_index_url
    end
  end
  
  def populate
    @group = Group.find(params[:id])
    if request.post? && params[:import_user]
      message = 'Stored and grouped: '
      params[:import_user].each do |i|
        u = params["user_#{i}".to_sym]
        u[:password] = u[:password_confirmation] = generate_password
        u[:activated_at] = Time.now
        user = User.new(u)
        if user.save!
          user.groups << @group
          user.send_group_welcomes(u[:password])
          message += "#{user.name}. "
        end
      end
      flash[:notice] = message
      redirect_to group_index_url

    elsif params[:userlist]
      @users = params[:userlist].split("\n").map { |line| line.split(/,\s*/).collect!{|n| n.chomp}}     # worst. csv parsing. ever.
      @users.collect!{|u| u.push(generate_login(u[1]))}
    end
  end


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



def addmany
  if @request.post?
    message = ''
    userlist = params[:userlist]
    groups = params[:groups].collect {|g| Group.find(g)} if params[:groups]
    users = userlist.split(/[\r\n]+/)
    users.each do |u|
      uf = {}
      uf[:name], uf[:email], uf[:password] = u.split(',')
      uf[:password] = generate_password if uf[:password].nil? or uf[:password].length < 5
      uf[:password_confirmation] = uf[:password]
      uf[:login] = uf[:name].gsub(/[^a-zA-Z0-9]+/, '')
      user = User.new(uf)
      user.groups << groups
      if user.save!
        message += "#{user.name} saved. "
      end
    end
    flash[:notice] = message
    redirect_to user_index_url
  end
end

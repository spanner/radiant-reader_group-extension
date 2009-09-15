class Admin::GroupsController < Admin::ResourceController
  require 'csv'
    
  before_filter :find_group, :only => [:show, :message, :populate, :add_reader, :remove_reader, :add_page, :remove_page]
  
  def show
    
  end
  
  # this should all be restfulised with a group messages controller (and model)
  
  def message
    if request.post? && params[:confirm]
      count = @group.send_message_to_all(params[:subject], params[:message].gsub(/^\s{3,}/, ''))
      flash[:notice] = "Message sent to #{count} member(s) of #{@group.name}."
      redirect_to admin_group_url(@group)
    end
  end

  def populate
    if request.post? && params[:invite_reader] || params[:import_reader]
      notice = ''
      if invites = params[:invite_reader]
        invites.each do |i|
          if reader = Reader.find_by_id(i)
            reader.groups << @group unless reader.is_in?(@group)
            @group.send_welcome_to(reader)
            notice += "#{reader.name} added to group. "
          end
        end
      end
      if imports = params[:import_reader]
        imports.each do |i|
          r = params["reader_#{i}".to_sym]
          r[:password] = r[:password_confirmation] = generate_password
          reader = Reader.new(r)
          reader.clear_password = r[:password]
          if reader.save!
            reader.groups << @group
            reader.send_invitation_message
            @group.send_welcome_to(reader)
            notice += "#{reader.name} account created. "
          end
        end
      end
      flash[:notice] = notice
      redirect_to admin_group_url(@group)
    else 
      @readers = readers_from_csv(params[:readerlist]) if params[:readerlist]
      response_for :singular
    end
  end
  

  private
  
    def find_group
      @group = Group.find(params[:id])
    end

    def readers_from_csv(readerdata)
      readers = []
      CSV::StringReader.parse(readerdata).each do |line|
        csv = line.collect {|value| value.gsub(/^ */, '').chomp}
        input = {}
        input[:honorific] = csv.shift if Radiant::Config['reader.use_honorifics?']
        [:name, :email, :login].each {|field| input[field] = csv.shift}
        r = Reader.find_by_email(input[:email]) || Reader.new(input)
        r.login = generate_login(input[:name]) if r.login.blank?
        r.valid?    # so that errors can be shown on the confirmation form
        readers << r
      end
      readers
    end

    def generate_login(name)
      logger.warn "... #{name}"
      names = name.split
      initials = names.map {|n| n.slice(0,1)}
      initials.pop
      initials.push(names.last).join('_').downcase
    end

    def generate_password(length=12)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
      Array.new(length, '').collect{chars[rand(chars.size)]}.join
    end
  
end

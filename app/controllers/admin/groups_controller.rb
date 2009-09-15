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
          r[:activated_at] = Time.now
          reader = Reader.new(r)
          if reader.save!
            reader.groups << @group
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
        values = line.collect {|value| value.gsub(/^ */, '').chomp}
        r = Reader.find_or_create_by_email(values[1])
        r.name ||= values[0]
        r.login ||= values[2] || generate_login(values[0])
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
      initials.push(names.last).join('_')
    end

    def generate_password(length=12)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
      Array.new(length, '').collect{chars[rand(chars.size)]}.join
    end
  
end

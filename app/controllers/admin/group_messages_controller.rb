class Admin::GroupMessagesController < Admin::ResourceController
  skip_before_filter :load_model
  before_filter :load_model, :except => :index
  before_filter :find_group
  
  # send link is on the show page (and small in the index view)
  # (which is shown after successful create or update)

  def create
    @group_message.update_attributes!(params[:group_message])
    announce_saved
    response_for :create
  end
  
  def preview
    render :layout => false
  end
  
  def deliver
    @group_message.deliver
    flash[:notice] = "message delivered"
    redirect_to admin_group_group_messages_url(@group)
  end

protected

  def continue_url(options)
    params[:continue] ? edit_admin_group_group_message_path(@group, model.id) : admin_group_group_message_path(@group, model.id)
  end
  
private

  def find_group
    @group = Group.find(params[:group_id])
    params[:group_message][:group_id] = params[:group_id] if params[:group_message]
  end

end

module AdminMessagesControllerExtensions
  def self.included(base)
    base.class_eval { 
      before_filter :get_group, :only => :new
    }
  end

protected

  def get_group
    model.group = Group.find(params[:group_id]) if params[:group_id]
  end
end




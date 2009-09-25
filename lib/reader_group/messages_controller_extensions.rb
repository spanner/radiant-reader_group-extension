module ReaderGroup::MessagesControllerExtensions
  def self.included(base)
    base.class_eval { 
      before_filter :get_group 

      def get_group
        logger.warn "!!  got group id #{params[:group_id]}"
        @group = Group.find_by_id(params[:group_id]) if params[:group_id]
      end
    }
  end

end




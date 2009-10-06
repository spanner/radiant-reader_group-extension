module MessagesControllerExtensions
  def self.included(base)
    base.class_eval { 
      prepend_before_filter :get_group 

    protected

      def get_group
        @group = Group.find_by_id(params[:group_id]) if params[:group_id]
      end

      def get_message
        @message = @group ? @group.messages.find(params[:id]) : current_reader.messages.find(params[:id])
        Rails.logger.warn "!!! got group message: #{@message.inspect}"
      end

      def get_messages
        @messages = @group ? @group.messages : current_reader.messages
      end

    }
  end

end




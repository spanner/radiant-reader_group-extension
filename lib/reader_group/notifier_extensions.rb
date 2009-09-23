module ReaderGroup::NotifierExtensions
  
  def self.included(base)
    base.class_eval {
      def group_welcome_message( reader, group )
        setup_email(reader)
        @subject = "Welcome to the #{group.name} group"
        @body[:group] = group
      end

      def message_with_group( reader, message )
        message_without_group( reader, message )
        @body[:group] = message.group
      end
      alias_method_chain :message, :group      
    }
  end
end

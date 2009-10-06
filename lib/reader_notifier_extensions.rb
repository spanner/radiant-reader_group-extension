module ReaderNotifierExtensions
  
  def self.included(base)
    base.class_eval {

      def message_with_group( reader, message, sender=nil )
        message_without_group( reader, message, sender )
        @body[:group] = message.group
      end
      alias_method_chain :message, :group      

    }
  end
end

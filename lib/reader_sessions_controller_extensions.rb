module ReaderSessionsControllerExtensions
  def self.included(base)

    base.class_eval { 
      
      def default_loggedin_url_with_group
        if page = @reader_session.reader.find_homepage
          page.url
        else
          default_loggedin_url_without_group
        end
      end
      alias_method_chain :default_loggedin_url, :group

    }
  end
  
end




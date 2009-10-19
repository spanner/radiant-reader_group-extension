module ReaderActivationsControllerExtensions
  def self.included(base)

    base.class_eval { 
      
      def default_activated_url_with_group
        if page = @reader.find_homepage
          page.url
        else
          default_activated_url_without_group
        end
      end
      alias_method_chain :default_activated_url, :group

    }
  end
  
end




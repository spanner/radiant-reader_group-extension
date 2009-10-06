module SiteControllerExtensions
  
  def self.included(base)
    base.class_eval {
      # to control access without ruining the cache we have set Page.cache? = false
      # for any page that has a group association. This should  prevent the relatively 
      # few private pages from being cached, and it remains safe to return any cached
      # page we find.
      
      def find_page_with_group_check(url)
        page = find_page_without_group_check(url)
        raise ReaderGroup::PermissionDenied if page && !page.visible_to?(current_reader)
        page
      end
        
      def show_page_with_group_check
        show_page_without_group_check
      rescue ReaderGroup::PermissionDenied
        flash[:error] = "Sorry: you don't have permission to see that page."
        redirect_to reader_permission_denied_url
      end
        
      alias_method_chain :find_page, :group_check
      alias_method_chain :show_page, :group_check
    }
  end
end




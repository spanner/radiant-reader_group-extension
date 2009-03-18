module ReaderGroup::Access    # for inclusion into SiteController
  
  def self.included(base)
    base.class_eval {
      session :disabled => false

      # to control access but retain cache efficiency we have set Page.cache? = false
      # to prevent the relatively few private pages from being cached. that way it's 
      # safe to return a cache hit if we find it and we can put the access control 
      # into show_uncached_page where it is already necessary to go to the database
      
      def find_page_with_group_check(url)
        page = find_page_without_group_check(url)
        raise Group::PermissionDeniedError if page && !page.visible_to(current_reader)
        page
      end
        
      def show_uncached_page_with_group_check(url)
        show_uncached_page_without_group_check(url)
        
      rescue Group::PermissionDeniedError
        flash[:error] = "Sorry: you don't have permission to see that page."
        if current_reader
          render :template => 'site/not_allowed'
        else
          redirect_to reader_login_url
        end
      end
        
      alias_method_chain :find_page, :group_check
      alias_method_chain :show_uncached_page, :group_check
    }
  end
end




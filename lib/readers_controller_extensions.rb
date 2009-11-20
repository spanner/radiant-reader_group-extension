module ReadersControllerExtensions
  
  def self.included(base)
    base.class_eval { before_filter :ensure_groups_subscribable, :only => [:update, :create] }
    base.add_form_partial 'readers/memberships'
  end

  def ensure_groups_subscribable
    if params[:reader] && params[:reader][:group_ids]
      params[:reader][:group_ids].each do |g|
        raise ActiveRecord::RecordNotFound unless Group.find(g).public?
      end
    end
    true
  rescue ActiveRecord::RecordNotFound
    false
  end

end




ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
    admin.resources :groups, :has_many => [:memberships, :permissions, :group_invitations, :messages]
  end
  map.resources :groups, :only => [] do |group|
    group.resources :messages, :only => [:index, :show], :member => [:preview]
  end
end

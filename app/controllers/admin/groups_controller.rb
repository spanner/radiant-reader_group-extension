class Admin::GroupsController < Admin::ResourceController
  skip_before_filter :load_model
  before_filter :load_model, :except => :index
end

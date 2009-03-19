module ReaderGroup::Site

  def self.included(base)
    base.class_eval %{
      has_many :groups
    } 
    super
  end

end

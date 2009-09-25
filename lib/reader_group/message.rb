module ReaderGroup::Message

  def self.included(base)
    base.class_eval {
      belongs_to :group

      def possible_readers_with_group
        group ? group.readers : possible_readers_without_group
      end
      alias_method_chain :possible_readers, :group
      
    }
  end

end

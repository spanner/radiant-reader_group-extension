module GroupUI

 def self.included(base)
   base.class_eval do

      attr_accessor :group
      alias_method :groups, :group

      def load_default_regions_with_group
        load_default_regions_without_group
        @group = load_default_group_regions
      end

      alias_method_chain :load_default_regions, :group

      protected

        def load_default_group_regions
          returning OpenStruct.new do |group|
            group.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_group edit_timestamp edit_buttons edit_membership edit_pages}
            end
            group.index = Radiant::AdminUI::RegionSet.new do |index|
              index.thead.concat %w{name_header home_header members_header pages_header modify_header}
              index.tbody.concat %w{name_cell home_cell members_cell pages_cell modify_cell}
              index.bottom.concat %w{buttons}
            end
            group.remove = group.index
            group.new = group.edit
          end
        end
      
    end
  end
end


module GroupUI

 def self.included(base)
   base.class_eval do

      attr_accessor :group
      alias_method :groups, :group

      def load_default_regions_with_group
        @group = load_default_group_regions
      end

      alias_method_chain :load_default_regions, :group

      protected

        def load_default_group_regions
          returning OpenStruct.new do |group|
            group.show = Radiant::AdminUI::RegionSet.new do |show|
              # reader list reuses reader.index regions
              show.thead.concat %w{title_header description_header modify_header}
              show.tbody.concat %w{title_cell description_cell modify_cell}
              show.bottom.concat %w{new_button}
              show.pages_head.concat %w{title_column_header modify_column_header}
              show.page.concat %w{title_column add_child_column remove_column}
            end
            group.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_title edit_homepage edit_description edit_notes}
              edit.form_bottom.concat %w{edit_timestamp edit_buttons}
            end
            group.index = Radiant::AdminUI::RegionSet.new do |index|
              index.thead.concat %w{name_header home_header members_header pages_header modify_header}
              index.tbody.concat %w{name_cell home_cell members_cell pages_cell modify_cell}
              index.bottom.concat %w{new_button}
            end
            group.remove = group.index
            group.new = group.edit
          end
        end
      
    end
  end
end


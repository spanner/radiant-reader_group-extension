class RenameJoins < ActiveRecord::Migration
  def self.up
    rename_table :groups_pages, :group_permissions
    rename_table :groups_readers, :group_memberships
  end

  def self.down
    rename_table :group_permissions, :groups_pages
    rename_table :group_memberships, :groups_readers
  end
end

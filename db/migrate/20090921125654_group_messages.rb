class GroupMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :group_id, :integer
  end

  def self.down
    remove_column :messages, :group_id
  end
end

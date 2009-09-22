class GroupMessages < ActiveRecord::Migration
  def self.up
    create_table :group_messages do |t|
      t.column :group_id, :integer
      t.column :site_id, :integer
      t.column :subject, :string
      t.column :body, :text
      t.column :filter_id, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :sent_at, :datetime
      t.column :created_by_id, :integer
      t.column :updated_by_id, :integer
      t.column :lock_version, :integer
    end
  end

  def self.down
    drop_table :group_messages
  end
end

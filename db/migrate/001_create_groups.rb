class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :notes, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by_id, :integer
      t.column :updated_by_id, :integer
      t.column :homepage_id, :integer
      t.column :site_id, :integer
      t.column :lock_version, :integer
    end

    create_table :groups_readers, :id => false do |t|
      t.column :group_id, :integer
      t.column :reader_id, :integer
    end

    create_table :groups_pages, :id => false do |t|
      t.column :group_id, :integer
      t.column :page_id, :integer
    end
  end

  def self.down
    drop_table :groups
    drop_table :groups_readers
    drop_table :groups_pages
  end
end

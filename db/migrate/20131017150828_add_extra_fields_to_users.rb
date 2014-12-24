class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_deleted, :boolean, :default => false
    add_column :users, :is_active, :boolean, :default => true
  end
end

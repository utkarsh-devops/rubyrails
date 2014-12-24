class AddIsDeletedToUses < ActiveRecord::Migration
  def change
    add_column :uses, :is_deleted, :boolean, :default => false
  end
end

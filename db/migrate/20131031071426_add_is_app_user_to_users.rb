class AddIsAppUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_app_user, :boolean, :default => true
  end
end

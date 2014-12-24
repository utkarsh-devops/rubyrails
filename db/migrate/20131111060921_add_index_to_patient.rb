class AddIndexToPatient < ActiveRecord::Migration
  def change
    add_index :patients, [:first_name, :last_name, :birth_date], :unique => true
  end
end

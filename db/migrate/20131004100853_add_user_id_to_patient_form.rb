class AddUserIdToPatientForm < ActiveRecord::Migration
  def change
    add_column :patient_forms, :user_id, :integer
    add_index :patient_forms, :user_id
  end
end

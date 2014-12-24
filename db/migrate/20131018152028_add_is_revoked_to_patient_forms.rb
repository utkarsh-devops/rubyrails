class AddIsRevokedToPatientForms < ActiveRecord::Migration
  def change
    add_column :patient_forms, :is_revoked, :boolean, :default => false
  end
end

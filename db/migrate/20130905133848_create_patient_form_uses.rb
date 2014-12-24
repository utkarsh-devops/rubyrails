class CreatePatientFormUses < ActiveRecord::Migration
  def change
    create_table :patient_form_uses do |t|
      t.references :patient_form
      t.references :use

      t.timestamps
    end
  end
end

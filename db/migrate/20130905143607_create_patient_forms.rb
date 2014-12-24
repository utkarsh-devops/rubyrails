class CreatePatientForms < ActiveRecord::Migration
  def change
    create_table :patient_forms do |t|
      t.text :notes
      t.boolean :follow_up_requested
      t.string :profile_image
      t.string :other_purpose
      t.date :expiry_date
      t.string :sign_image
      t.string :guardian_first_name
      t.string :guardian_last_name

      t.references :release
      t.references :event
      t.references :patient
      t.timestamps
    end
  end
end

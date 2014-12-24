class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :version
      t.text :english_desc
      t.text :spanish_desc

      t.timestamps
    end
  end
end

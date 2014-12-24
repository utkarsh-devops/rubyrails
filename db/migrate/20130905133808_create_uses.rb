class CreateUses < ActiveRecord::Migration
  def change
    create_table :uses do |t|
      t.string :description

      t.timestamps
    end
  end
end

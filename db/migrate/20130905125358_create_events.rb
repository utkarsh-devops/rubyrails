class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :event_date
      t.time :event_time
      t.boolean :is_permanent_event

      t.references :user
      t.timestamps
    end
  end
end

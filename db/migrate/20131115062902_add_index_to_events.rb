class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, [:name, :event_date, :is_permanent_event], :unique => true
  end
end

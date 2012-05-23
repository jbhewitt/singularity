class AddIndexToEntrants < ActiveRecord::Migration
  def change
    add_index :entrants, [ :person_id, :event_id ], :unique => true, :name => 'by_person_and_event'
  end
end

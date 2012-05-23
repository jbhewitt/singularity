class CreateEntrants < ActiveRecord::Migration
  def change
    create_table :entrants do |t|
      t.string :name
      t.boolean :response
      t.integer :player_id
      t.integer :event_id

      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :meetup_id

      t.timestamps
    end
  end
end

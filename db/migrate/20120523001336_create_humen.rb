class CreateHumen < ActiveRecord::Migration
  def change
    create_table :humen do |t|
      t.string :name
      t.string :gamername
      t.integer :meetup_id
      t.string :city
      t.string :state
      t.string :meetup_url
      t.string :avatar

      t.timestamps
    end
  end
end

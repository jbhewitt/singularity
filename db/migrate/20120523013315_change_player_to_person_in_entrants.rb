class ChangePlayerToPersonInEntrants < ActiveRecord::Migration
  def up
           remove_column :entrants, :player_id
           add_column :entrants, :person_id, :integer

  end

  def down
    remove_column :entrants, :person_id
    add_column :entrants, :player_id, :integer
  end
end

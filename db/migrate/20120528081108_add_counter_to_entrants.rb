class AddCounterToEntrants < ActiveRecord::Migration
  def change
    add_column :entrants, :printcount, :integer
  end
end

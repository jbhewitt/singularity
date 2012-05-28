class AddBadgeToEntrants < ActiveRecord::Migration
  def change
    add_column :entrants, :badge, :string
  end
end

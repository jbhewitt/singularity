class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :name
      t.boolean :used

      t.timestamps
    end
  end
end

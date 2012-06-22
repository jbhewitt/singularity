class AddPrintToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :printed, :boolean
  end
end

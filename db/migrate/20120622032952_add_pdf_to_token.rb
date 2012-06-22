class AddPdfToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :pdf, :string
  end
end

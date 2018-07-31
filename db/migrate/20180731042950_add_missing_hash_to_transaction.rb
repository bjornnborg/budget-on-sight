class AddMissingHashToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :missing_hash, :string
    add_index :transactions, :missing_hash
  end
end

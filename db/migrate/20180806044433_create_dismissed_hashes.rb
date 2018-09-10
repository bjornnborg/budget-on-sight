class CreateDismissedHashes < ActiveRecord::Migration[5.2]
  def change
    create_table(:dismissed_hashes, id: :integer) do |t|
      t.string :missing_hash

      t.timestamps
    end
    add_index :dismissed_hashes, :missing_hash
  end
end

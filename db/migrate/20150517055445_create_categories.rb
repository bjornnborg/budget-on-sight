class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :type
      t.string :description
      t.string :group
      t.decimal :value
      t.string :frequency
      t.boolean :active

      t.timestamps null: false
    end
  end
end

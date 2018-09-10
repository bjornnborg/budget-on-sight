class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.references :category, index: true, foreign_key: true
      t.string :payee

      t.timestamps null: false
    end
  end
end

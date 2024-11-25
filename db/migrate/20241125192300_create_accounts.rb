class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :title
      t.float :balance
      t.integer :percentage
      t.references :general_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

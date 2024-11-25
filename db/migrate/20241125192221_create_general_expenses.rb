class CreateGeneralExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :general_expenses do |t|
      t.string :title
      t.float :amount
      t.boolean :recurrent
      t.integer :recurrence_frequency
      t.references :general_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateGeneralAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :general_accounts do |t|
      t.float :net_income

      t.timestamps
    end
  end
end

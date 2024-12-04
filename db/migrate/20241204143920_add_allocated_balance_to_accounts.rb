class AddAllocatedBalanceToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :allocated_balance, :decimal
  end
end

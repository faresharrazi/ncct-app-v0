class GeneralExpense < ApplicationRecord
  belongs_to :general_account

  validates :title, :amount, presence: true

  # Callbacks for creating, updating, and destroying expenses
  after_create :update_accounts_on_create
  after_update :update_accounts_on_update
  after_destroy :update_accounts_on_destroy

  private

  # Allocate expense to accounts and recalculate net income
  def update_accounts_on_create
    distribute_to_accounts(-amount)
    update_allocated_balances
    general_account.calculate_net_income
  end

  # Reallocate expense difference to accounts and recalculate net income
  def update_accounts_on_update
    previous_amount = amount_before_last_save || 0
    difference = amount - previous_amount
    distribute_to_accounts(-difference)
    update_allocated_balances
    general_account.calculate_net_income
  end

  # Reverse expense allocation on destroy and recalculate net income
  def update_accounts_on_destroy
    distribute_to_accounts(amount)
    update_allocated_balances
    general_account.calculate_net_income
  end

  # Distribute expense adjustments to accounts
  def distribute_to_accounts(amount_to_distribute)
    general_account.accounts.each do |account|
      adjustment = amount_to_distribute * (account.percentage / 100.0)
      account.update!(balance: [ account.balance + adjustment, 0 ].max) # Ensure balance is not negative
    end
  end

  # Update allocated balances for accounts
  def update_allocated_balances
    general_account.accounts.each(&:set_allocated_balance)
  end
end

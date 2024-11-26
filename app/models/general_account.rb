class GeneralAccount < ApplicationRecord
  has_many :general_incomes
  has_many :general_expenses
  has_many :accounts

  def calculate_net_income
    # Calculate net income as total incomes - total expenses
    self.net_income = general_incomes.sum(:amount) - general_expenses.sum(:amount)
    save!

    # Update all account balances based on net income and account percentages
    update_account_balances
  end

  private

  def update_account_balances
    accounts.each do |account|
      # Recalculate account balance based on its percentage of the net income
      account.update(balance: (net_income * (account.percentage / 100.0)).round(2))
    end
  end
end

class GeneralAccount < ApplicationRecord
  has_many :general_incomes
  has_many :general_expenses
  has_many :accounts

  def calculate_net_income
    self.net_income = general_incomes.sum(:amount) - general_expenses.sum(:amount)
    save
    update_account_balances
  end

  private

  def update_account_balances
    accounts.each do |account|
      account.update(balance: (net_income * (account.percentage / 100.0)).round(2))
    end
  end
end

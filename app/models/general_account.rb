class GeneralAccount < ApplicationRecord
  has_many :general_incomes
  has_many :general_expenses
  has_many :accounts

  def calculate_net_income
    Rails.logger.info("Calculating net income for GeneralAccount ##{id}, triggered by #{caller[0..2]}")
    
    total_incomes = general_incomes.sum(:amount)
    total_expenses = general_expenses.sum(:amount)
    total_transactions = accounts.joins(:transactions).sum(:amount)

    self.net_income = total_incomes - total_expenses - total_transactions
    save!
    Rails.logger.info("Net income updated to: #{net_income}")
  end
end
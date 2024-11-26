class GeneralAccount < ApplicationRecord
  has_many :general_incomes
  has_many :general_expenses
  has_many :accounts

  def calculate_net_income

    total_incomes = general_incomes.sum(:amount)
    total_expenses = general_expenses.sum(:amount)
    total_transactions = accounts.joins(:transactions).sum(:amount)

    self.net_income = total_incomes - total_expenses - total_transactions
    save!
    distribute_net_income
  end

    def distribute_net_income
   Rails.logger.debug("Distribution logic removed for better balance tracking.")
  end
  
end

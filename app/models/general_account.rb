class GeneralAccount < ApplicationRecord
  has_many :general_incomes
  has_many :general_expenses
  has_many :accounts

  def calculate_net_income
    self.net_income = general_incomes.sum(:amount) - general_expenses.sum(:amount)
    save
  end
end

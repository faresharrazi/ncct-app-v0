class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories
  has_many :transactions

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validate :validate_total_percentage

  after_save :update_balance

  def transfer_to(other_account, amount)
    return if self.balance < amount

    self.transactions.create!(name: "Transfer to #{other_account.title}", amount: -amount, category: nil)
    self.update!(balance: self.balance - amount)

    other_account.transactions.create!(name: "Transfer from #{self.title}", amount: amount, category: nil)
    other_account.update!(balance: other_account.balance + amount)
  end

  private

  # Ensure total percentage of all accounts does not exceed 100%
  def validate_total_percentage
    total_percentage = general_account.accounts.sum(:percentage)
    if new_record? && total_percentage + percentage > 100
      errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
    elsif !new_record? && total_percentage - self.percentage_was + percentage > 100
      errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
    end
  end

  # Automatically calculate balance based on the percentage of the General Account's net income
  def update_balance
    self.update_column(:balance, (general_account.net_income * (percentage / 100.0)).round(2))
  end

end

class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validate :validate_total_percentage

  after_commit :update_balance, on: [:create, :update]

  def transfer_to(other_account, amount)
    raise "Insufficient balance" if self.balance < amount

    self.transactions.create!(name: "Transfer to #{other_account.title}", amount: -amount, category: nil)
    self.update!(balance: self.balance - amount)

    other_account.transactions.create!(name: "Transfer from #{self.title}", amount: amount, category: nil)
    other_account.update!(balance: other_account.balance + amount)
  end

  private

  def validate_total_percentage
    total_percentage = general_account.accounts.sum(:percentage)
    if new_record?
      if total_percentage + percentage > 100
        errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
      end
    elsif total_percentage - self.percentage_before_last_save + percentage > 100
      errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
    end
  end

  def update_balance
    update_column(:balance, (general_account.net_income * (percentage / 100.0)).round(2))
  end
end

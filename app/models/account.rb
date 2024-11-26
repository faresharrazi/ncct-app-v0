class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validate :validate_total_percentage

  def update_balance
    Rails.logger.info("Updating balance for Account ##{id}")

    # Percentage-based share of the net income
    percentage_of_net_income = (general_account.net_income * (percentage / 100.0)).round(2)

    # Total amount of transactions for this account
    total_transactions = transactions.sum(:amount)

    # New balance = percentage share - transactions
    new_balance = percentage_of_net_income - total_transactions
    update!(balance: new_balance)

    Rails.logger.info("New balance for Account ##{id}: #{new_balance}")
  end

  private

  def validate_total_percentage
    total_percentage = general_account.accounts.sum(:percentage)
    previous_percentage = percentage_before_last_save || 0

    if new_record?
      if total_percentage + percentage > 100
        errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
      end
    elsif total_percentage - previous_percentage + percentage > 100
      errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
    end
  end
end

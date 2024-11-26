class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validate :validate_total_percentage

  before_create :initialize_balance_and_category

  def update_balance
    Rails.logger.info("Updating balance for Account ##{id}")

    # Percentage-based share of the general account's net income
    percentage_of_net_income = (general_account.net_income * (percentage / 100.0)).round(2)

    # Total transaction amounts for this account
    total_transactions = transactions.sum(:amount)

    # Calculate the new balance
    new_balance = percentage_of_net_income - total_transactions
    update!(balance: new_balance)

    Rails.logger.info("New balance for Account ##{id}: #{new_balance}")
  end

  private

  def initialize_balance_and_category
    # Calculate initial balance based on percentage of general account's net income
    initial_balance = (general_account.net_income || 0) * (percentage / 100.0)
    self.balance = initial_balance.round(2)

    # Create a default category for the account
    categories.build(name: title)
  end

  def validate_total_percentage
    general_account.with_lock do
      total_percentage = general_account.accounts.sum(:percentage)
      previous_percentage = percentage_before_last_save || 0

      if total_percentage - previous_percentage + percentage > 100
        errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
      end
    end
  end
end

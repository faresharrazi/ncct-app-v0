class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  # Validations
  validates :name, :amount, :account_id, :category_id, presence: true
  validate :sufficient_account_balance

  # Callbacks
  after_create :deduct_amount_from_account_balance
  after_update :adjust_account_balance
  after_destroy :restore_amount_to_account_balance

  # Scopes
  scope :by_account, ->(account_id) { where(account_id: account_id) if account_id.present? }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_date_range, ->(start_date, end_date) {
    where(date: start_date..end_date) if start_date.present? && end_date.present?
  }
  scope :by_amount_range, ->(min_amount, max_amount) {
    where(amount: min_amount..max_amount) if min_amount.present? && max_amount.present?
  }
  scope :search_by_name, ->(query) {
    where("name ILIKE ?", "%#{query}%") if query.present?
  }

  private

  # Deduct transaction amount from account balance after creation
  def deduct_amount_from_account_balance
    account.update!(balance: account.balance - amount)
    account.general_account.calculate_net_income
  end

  # Adjust account balance when a transaction is updated
  def adjust_account_balance
    if saved_change_to_amount?
      difference = amount - amount_before_last_save
      account.update!(balance: account.balance - difference)
      account.general_account.calculate_net_income
    end
  end

  # Restore the transaction amount to account balance when destroyed
  def restore_amount_to_account_balance
    account.update!(balance: account.balance + amount)
    account.general_account.calculate_net_income
  end

  # Ensure the account has sufficient balance for this transaction
  def sufficient_account_balance
    Rails.logger.debug("Validating account balance for transaction: #{name}, amount: #{amount}, account balance: #{account.balance}")
    
    if account.balance < amount
      Rails.logger.debug("Insufficient balance error for transaction: #{name}")
      errors.add(:amount, "cannot exceed the account balance")
    end
  end
end


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

  private

  # Deduct transaction amount from account balance after creation
  def deduct_amount_from_account_balance
    Rails.logger.debug("Deducting #{amount} from account #{account.id} (#{account.title})")
    account.update!(balance: account.balance - amount)
    account.general_account.calculate_net_income # Recalculate net income
  end

  # Adjust account balance when a transaction is updated
  def adjust_account_balance
    if saved_change_to_amount?
      difference = amount - amount_before_last_save
      Rails.logger.debug("Adjusting account #{account.id} (#{account.title}) by #{difference}")
      account.update!(balance: account.balance - difference)
      account.general_account.calculate_net_income
    end
  end

  # Restore the transaction amount to account balance when destroyed
  def restore_amount_to_account_balance
    Rails.logger.debug("Restoring #{amount} to account #{account.id} (#{account.title})")
    account.update!(balance: account.balance + amount)
    account.general_account.calculate_net_income
  end

  # Ensure the account has sufficient balance for this transaction
  def sufficient_account_balance
    Rails.logger.debug("Validating account balance for transaction: #{name}, amount: #{amount}, account balance: #{account.balance}")
    if account.balance < amount
      errors.add(:amount, "cannot exceed the account balance")
    end
  end
end

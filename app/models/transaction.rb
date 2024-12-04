class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  # Validations
  validates :name, :amount, :account_id, :category_id, presence: true
  validate :sufficient_account_balance, if: -> { account.present? }

  # Callbacks
  after_create :deduct_amount_from_account_balance
  after_update :adjust_account_balance
  after_destroy :restore_amount_to_account_balance

  private

  # Ensure the account has sufficient balance for this transaction
  def sufficient_account_balance
    if new_record? # Validation for new transactions
      if account.balance < amount.to_f
        errors.add(:amount, "cannot exceed the account balance")
      end
    elsif saved_change_to_amount? # Validation for updates
      difference = amount - amount_before_last_save
      if difference.positive? && account.balance < difference
        errors.add(:amount, "exceeds the available balance with the updated amount")
      end
    end
  end

  # Deduct transaction amount from account balance after creation
  def deduct_amount_from_account_balance
    account.update!(balance: account.balance - amount)
  end

  # Adjust account balance when a transaction is updated
  def adjust_account_balance
    if saved_change_to_amount?
      difference = amount - amount_before_last_save
      account.update!(balance: account.balance - difference)
    end
  end

  # Restore the transaction amount to account balance when destroyed
  def restore_amount_to_account_balance
    account.update!(balance: account.balance + amount)
  end
end

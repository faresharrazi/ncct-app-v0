class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  validates :name, :amount, :account_id, :category_id, presence: true
  validate :sufficient_account_balance

  after_create :update_account_and_general_account

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

  def update_account_and_general_account
    Rails.logger.info("Updating Account ##{account.id} and GeneralAccount ##{account.general_account.id} after transaction")

    # Deduct the transaction amount from the account balance
    account.update(balance: account.balance - amount)

    # Recalculate net income for the GeneralAccount
    account.general_account.calculate_net_income
  end

  def sufficient_account_balance
    if account.balance < amount
      errors.add(:amount, "cannot exceed the account balance")
    end
  end
end

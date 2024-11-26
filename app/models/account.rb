class Account < ApplicationRecord
  belongs_to :general_account
  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy

  # Validations
  validates :title, :percentage, presence: true
  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validate :total_percentage_cannot_exceed_100, on: :create

  # Callbacks
  before_save :update_balance_based_on_percentage, if: :new_record?

  private

  # Update account balance based on percentage of general account's net income
  def update_balance_based_on_percentage
    if general_account.present? && percentage.present?
      self.balance = general_account.net_income * (percentage / 100.0)
    else
      self.balance = 0
    end
  end

  # Ensure the total percentage of all accounts under the same general account does not exceed 100%
  def total_percentage_cannot_exceed_100
    return unless general_account

    total_percentage = general_account.accounts.where.not(id: id).sum(:percentage) + percentage
    if total_percentage > 100
      errors.add(:percentage, "Total percentage of all accounts cannot exceed 100%")
    end
  end
end

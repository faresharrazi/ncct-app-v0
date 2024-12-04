class Account < ApplicationRecord
  belongs_to :general_account
  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy

  # Validations
  validates :title, :percentage, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0 } # Ensure percentage is at least 0%
  validate :percentage_within_available_range

  # Callbacks
  before_save :set_initial_balances, if: :new_record?

  def set_allocated_balance
    # Calculate allocated balance based on the general account's net income and account percentage
    self.allocated_balance = general_account.net_income * (percentage / 100.0)
    save! # Persist the updated allocated balance
  end

  private

  # Set initial balance and allocated balance based on percentage of general account's net income
  def set_initial_balances
    if general_account.present? && percentage.present?
      # Calculate balances based on net income
      self.allocated_balance = general_account.net_income * (percentage / 100.0)
      self.balance = allocated_balance
    else
      self.allocated_balance = 0
      self.balance = 0
    end
  end

  # Custom validation to ensure the percentage does not exceed the available percentage
  def percentage_within_available_range
    return unless general_account

    available_percentage = 100 - general_account.accounts.where.not(id: id).sum(:percentage)
    if percentage.present? && percentage > available_percentage
      errors.add(:percentage, "must not exceed the available percentage (#{available_percentage}%)")
    end
  end
end

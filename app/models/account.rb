class Account < ApplicationRecord
  belongs_to :general_account
  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy

  # Validations
  validates :title, :percentage, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0 } # Ensure percentage is at least 0%
  validate :percentage_within_available_range

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

  # Custom validation to ensure the percentage does not exceed the available percentage
  def percentage_within_available_range
    return unless general_account

    available_percentage = 100 - general_account.accounts.where.not(id: id).sum(:percentage)
    if percentage.present? && percentage > available_percentage
      errors.add(:percentage, "must not exceed the available percentage (#{available_percentage}%)")
    end
  end
end

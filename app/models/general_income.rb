class GeneralIncome < ApplicationRecord
  belongs_to :general_account

  validates :title, :amount, presence: true

  after_create :allocate_to_accounts
  after_update :reallocate_to_accounts
  after_destroy :update_general_account_net_income

  scope :within_date_range, ->(start_date, end_date) {
    where(date: start_date..end_date) if start_date && end_date
  }

  private

  def allocate_to_accounts
    general_account.accounts.each do |account|
      addition = amount * (account.percentage / 100.0)
      account.update!(balance: account.balance + addition)
    end
    general_account.calculate_net_income
  end

  def reallocate_to_accounts
    previous_amount = amount_before_last_save
    difference = amount - previous_amount

    general_account.accounts.each do |account|
      adjustment = difference * (account.percentage / 100.0)
      account.update!(balance: account.balance + adjustment)
    end
    general_account.calculate_net_income
  end

  def update_general_account_net_income
    general_account.calculate_net_income
  end
end


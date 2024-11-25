class GeneralIncome < ApplicationRecord
  after_create :allocate_to_accounts
  belongs_to :general_account
  validates :title, :amount, presence: true

  def allocate_to_accounts
  general_account.accounts.each do |account|
    account.update(balance: account.balance + (amount * account.percentage / 100))
  end
  general_account.calculate_net_income
end
end
class GeneralExpense < ApplicationRecord
  belongs_to :general_account
  validates :title, :amount, presence: true

  after_create :allocate_to_accounts
  after_destroy :update_general_account_net_income

  private

  def allocate_to_accounts
    general_account.accounts.each do |account|
      account_balance = account.balance || 0
      reduction = amount * (account.percentage / 100.0)
      account.update!(balance: account.balance - reduction)
    end
    general_account.calculate_net_income
  end

  def update_general_account_net_income
    general_account.calculate_net_income
  end
end

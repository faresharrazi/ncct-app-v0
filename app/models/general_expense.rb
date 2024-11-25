class GeneralExpense < ApplicationRecord
  belongs_to :general_account
  validates :title, :amount, presence: true

  after_create :allocate_expense_to_accounts

  private

  def allocate_expense_to_accounts
    # Reduce balances of accounts based on their percentage
    general_account.accounts.each do |account|
      reduction = amount * (account.percentage / 100.0)
      account.update(balance: account.balance - reduction)
    end
    # Update the GeneralAccount's net income
    general_account.calculate_net_income
  end
end

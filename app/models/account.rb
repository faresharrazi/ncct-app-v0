class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories
  has_many :transactions

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  def transfer_to(other_account, amount)
    return if self.balance < amount

    self.transactions.create!(name: "Transfer to #{other_account.title}", amount: -amount, category: nil)
    self.update!(balance: self.balance - amount)

    other_account.transactions.create!(name: "Transfer from #{self.title}", amount: amount, category: nil)
    other_account.update!(balance: other_account.balance + amount)
  end

end

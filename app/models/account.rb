class Account < ApplicationRecord
  belongs_to :general_account
  has_many :categories
  has_many :transactions

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end

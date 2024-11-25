class GeneralExpense < ApplicationRecord
  belongs_to :general_account
  validates :title, :amount, presence: true
end

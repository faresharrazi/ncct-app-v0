class Category < ApplicationRecord
  belongs_to :account
  has_many :transactions
  before_destroy :ensure_no_transactions

  validates :name, presence: true, uniqueness: { scope: :account_id }
  private

  def ensure_no_transactions
    if transactions.exists?
      errors.add(:base, "Cannot delete category with associated transactions.")
      throw(:abort)
    end
  end
end